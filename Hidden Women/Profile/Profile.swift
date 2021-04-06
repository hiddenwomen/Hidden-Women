//
//  Profile.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 18/3/21.
//

import Foundation
import SwiftUI
import Firebase

let oneWeek = 7 * 24 * 60 * 60

struct Message: Identifiable {
    let from: String
    let to: String
    let text: String
    let time: Int
    let read: Bool
    let id = UUID()
    
    func toDict() -> [String: String] {
        return [
            "from": self.from,
            "to": self.to,
            "text": self.text,
            "time": String(self.time),
            "read": String(self.read)
        ]
    }
}

class Profile: ObservableObject, Identifiable {
    @Published var userId: String
    @Published var name: String
    @Published var email: String
    @Published var favourites: [String] = []
    @Published var picture: UIImage? = UIImage(named: "unknown")
    @Published var pictureFileName: String = ""
    @Published var friendIDs: [String] = []
    @Published var friends: [Profile] = []
    @Published var gameResults: [GameResult] = []
    @Published var friendRequests: [String] = []
    
    var points: Int {
        let limit = Int(Date().timeIntervalSince1970) - oneWeek
        return gameResults.filter{$0.date > limit}.map{$0.points}.reduce(0, +)
    }
    var id: UUID = UUID()
    
    init(userId: String = "", name: String = "", email: String = "", favourites: [String] = [], pictureFileName: String = "", gameResults: [GameResult] = []) {
        self.userId = userId
        self.name = name
        self.email = email
        self.favourites = favourites
        self.pictureFileName = pictureFileName
        self.gameResults = gameResults
    }
        
    func show() {
        print("DEBUG: Name:           \(self.name)")
        print("DEBUG: Email:          \(self.email)")
        print("DEBUG: Favourites:     \(self.favourites)")
        print("DEBUG: Picture file:   \(self.pictureFileName)")
        print("DEBUG: FriendIDs:      \(self.friendIDs)")
        print("DEBUG: FriendRequests: \(self.friendRequests)")
        //print("DEBUG: GameResults:    \(self.gameResults)")
    }
}

struct GameResult: Identifiable {
    let date: Int
    let gameType: String
    let points: Int
    let id: UUID = UUID()
}

func updateGameResults(profile: Profile, userID: String) {
    var d: [[String: Any]] = []
    for result in profile.gameResults {
        d.append([
            "date": result.date,
            "gameType": result.gameType,
            "points": result.points
        ])
    }
    Firestore.firestore().collection("users").document(userID).updateData(["gameResults": d])
}

func updateProfilePicture(userID: String, profile: Profile, picture: UIImage?, onError: @escaping (Error) -> Void) {
    profile.picture = picture?.scalePreservingAspectRatio(targetSize: CGSize(width: 200.0, height: 200.0))
    let pictureData = profile.picture?.jpegData(compressionQuality: 0.9) ?? Data()
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpg"
    let newFileName = "\(UUID()).jpg"
    Storage.storage().reference().child("\(userID)/\(newFileName)").putData(pictureData, metadata: metadata) { metadata, error in
        if let error = error {
            onError(error)
        } else {
            profile.pictureFileName = newFileName
            Firestore.firestore()
                .collection("users")
                .document(userID)
                .updateData([
                    "pictureFileName": newFileName
                ]) {
                    error in
                    if let error = error {
                        onError(error)
                    }
                }
        }
    }
}

func getProfilePicture(userID: String, profile: Profile, onCompletion: @escaping () -> Void ) {
    let picture = Storage.storage().reference().child("\(userID)/\(profile.pictureFileName)")
    picture.getData(maxSize: 128 * 1024 * 1024) { data, error in
        if let _ = error {
            profile.picture = UIImage(named: "unknown")
        } else {
            profile.picture = UIImage(data: data!) ?? UIImage(named: "unknown")
            onCompletion()
        }
    }
    
}

func updateProfileName(userID: String, name: String, onError: @escaping (Error) -> Void) {
    Firestore.firestore()
        .collection("users")
        .document(userID)
        .updateData(["name": name]) { error in
            if let error = error {
                onError(error)
            }
        }
}

func sendFriendRequest(destinationId: String, withMyProfile: Profile, onError: @escaping (Error) -> Void) {
    Firestore.firestore()
        .collection("users")
        .document(destinationId)
        .updateData([
            "friendRequests": FieldValue.arrayUnion([withMyProfile.email])
        ]) {
            error in
            if let error = error {
                onError(error)
            }
        }
}

func getUserId(forEmail: String, onError: @escaping (Error) -> Void, onCompletion: @escaping (DocumentSnapshot) -> Void) {
    Firestore.firestore()
        .collection("emails")
        .document(forEmail.lowercased())
        .getDocument { document, error in
            if let error = error {
                onError(error)
            } else if let document = document {
                onCompletion(document)
            }
        }
}

func getProfile(forEmail: String, onError: @escaping (Error) -> Void, onCompletion: @escaping (DocumentSnapshot) -> Void) {
    Firestore.firestore()
        .collection("emails")
        .document(forEmail.lowercased())
        .getDocument { document, error in
            if let error = error {
                onError(error)
            } else if let document = document {
                onCompletion(document)
            }
        }
}

func updateFriendRequestForAcceptance(userID: String, friendRequest: String, friendUserId: String) {
    Firestore.firestore()
        .collection("users")
        .document(userID)
        .updateData([
            "friendRequests": FieldValue.arrayRemove([friendRequest]),
            "friends": FieldValue.arrayUnion([friendUserId])
        ])
    Firestore.firestore()
        .collection("users")
        .document(friendUserId)
        .updateData([
            "friends": FieldValue.arrayUnion([userID])
        ])
}

func updateProfileToRemoveFriendRequest(userID: String, friendRequest: String) {
    Firestore.firestore()
        .collection("users")
        .document(userID)
        .updateData([
            "friendRequests": FieldValue.arrayRemove([friendRequest])
        ])
}

func updateFavourites(userID: String, profile: Profile, onError: @escaping (Error) -> Void) {
    Firestore.firestore().collection("users").document(userID).updateData(
        ["favourites": profile.favourites]
    ) { error in
        if let error = error {
            onError(error)
        }
    }
}

func getPeopleWithSimilarInterests(favourites: [String], onError: @escaping (Error) -> Void, onCompletion: @escaping (QuerySnapshot) -> Void) {
    if favourites.count > 0 {
        Firestore.firestore()
            .collection("users")
            .whereField("favourites", arrayContainsAny: favourites)
            .getDocuments() { snapshot, error in
                if let error = error {
                    onError(error)
                } else if let document = snapshot {
                    onCompletion(document)
                }
            }
    }
}

func signIn(withEmail: String, password: String, onError: @escaping (Error) -> Void, onCompletion: @escaping (AuthDataResult) -> Void) {
    Auth.auth().signIn(withEmail: withEmail, password: password) { authResult, error in
        if let error = error {
            onError(error)
        } else if let authResult = authResult {
            onCompletion(authResult)
        }
    }
}

func signUp(withEmail: String, password: String, profile: Profile, onError: @escaping (Error) -> Void, onCompletion: @escaping (AuthDataResult) -> Void) {
    Auth.auth().createUser(withEmail: withEmail, password: password) { user, error in
        if let error = error {
            onError(error)
        } else {
            Auth.auth().signIn(withEmail: withEmail, password: password) { authResult, error in
                if let error = error {
                    onError(error)
                } else if let authResult = authResult {
                    let userID = authResult.user.uid
                    profile.name = withEmail.components(separatedBy: "@")[0]
                    profile.email = withEmail
                    profile.favourites = []
                    profile.gameResults = []
                    profile.friendRequests = []
                    profile.pictureFileName = ""
                    profile.picture = UIImage(named: "unknown")
                    Firestore.firestore()
                        .collection("users")
                        .document(userID)
                        .setData([
                            "name": profile.name,
                            "email": profile.email,
                            "favourites": profile.favourites,
                            "pictureFileName": profile.pictureFileName,
                            "gameResults": profile.gameResults,
                            "friendRequests": profile.friendRequests
                        ]) { error in
                            if let error = error{
                                onError(error)
                            }
                        }
                    Firestore.firestore()
                        .collection("emails")
                        .document(profile.email.lowercased())
                        .setData([
                            "userId": userID
                        ]) { error in
                            if let error = error{
                                onError(error)
                            }
                        }
                    onCompletion(authResult)
                }
            }
        }
    }
}

func resetPassword(withEmail: String, onError: @escaping (Error) -> Void, onCompletion: @escaping () -> Void) {
    Auth.auth().sendPasswordReset(withEmail: withEmail) { error in
        if let error = error {
            onError(error)
        } else {
            onCompletion()
        }
    }
}

func listenToAndUpdateProfile(userID: String, profile: Profile) -> ListenerRegistration {
    return Firestore.firestore()
        .collection("users")
        .document(userID)
        .addSnapshotListener { document, error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            } else if let _ = document {
                loadProfile(userID: userID, profile: profile, andFriends: true) // TODO: Repensar carga de amigos: loadFriendsProfiles
                //loadProfileFromDocument(userID: userID, profile: profile, document: document)
            }
        }
}


struct ChatMessage {
    let author: String
    let text: String
    let time: Int
    
    func toDict() -> [String: String] {
        return [
            "author": author,
            "text": text,
            "time": String(time)
        ]
    }
}

class Chat: ObservableObject {
    @Published var lastAccess: [String: Int]
    @Published var messages: [ChatMessage]
    
    init(lastAccess: [String: Int], messages: [ChatMessage]) {
        self.lastAccess = lastAccess
        self.messages = messages
    }
}

func loadChatFromDocument(aId: String, bId: String, document: DocumentSnapshot, chat: Chat) {
    let data = document.data() ?? [aId: 0, bId: 0, "messages": []]
    chat.lastAccess[aId] = data[aId] as? Int ?? 0
    chat.lastAccess[bId] = data[bId] as? Int ?? 0
    chat.messages = []
    
    let dataMessages = data["messages"] as? [[String: String]] ?? []
    for message in dataMessages {
        let author = message["author"] ?? ""
        let text = message["text"] ?? ""
        let time = Int(message["time"] ?? "") ?? 0
        chat.messages.append(ChatMessage(author: author, text: text, time: time))
    }
}

func loadChat(aId: String, bId: String, chat: Chat, onError: @escaping (Error) -> Void) {
    let key = aId < bId ? "\(aId)::\(bId)" : "\(bId)::\(aId)"
    Firestore.firestore()
        .collection("chats")
        .document(key)
        .getDocument { documentSnapshot, error in
            if let error = error {
                onError(error)
            } else if let documentSnapshot = documentSnapshot {
                loadChatFromDocument(aId: aId, bId: bId, document: documentSnapshot, chat: chat)
            }
        }
}

func listenToChat(aId: String, bId: String, chat: Chat, onChange: @escaping () -> Void) -> ListenerRegistration {
    let key = aId < bId ? "\(aId)::\(bId)" : "\(bId)::\(aId)"
    return Firestore.firestore()
        .collection("chats")
        .document(key)
        .addSnapshotListener { document, error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            } else if let document = document {
                print("ESCUCHANDO CHATS")
                loadChatFromDocument(aId: aId, bId: bId, document: document, chat: chat)
                onChange()
            }
        }
}


func sendChatMessage(aId: String, bId: String, message: ChatMessage, onError: @escaping (Error) -> Void) {
    let key = aId < bId ? "\(aId)::\(bId)" : "\(bId)::\(aId)"
    let reference  =  Firestore.firestore().collection("chats").document(key)
    reference.getDocument() { documentSnapshot, error in
        if let error = error {
            onError(error)
        } else if let documentSnapshot = documentSnapshot {
            if documentSnapshot.exists {
                reference
                .updateData([
                    "messages": FieldValue.arrayUnion([message.toDict()])
                ]) { error in
                    if let error = error {
                        onError(error)
                    }
                }
            } else {
                reference.setData([
                    "lastAcces" : [
                        aId: 0,
                        bId: 0
                    ],
                    "messages": [
                        message.toDict()
                    ]
                ])
            }
        }
    }

}


func loadProfileFromDocument(userID: String, profile: Profile, document: DocumentSnapshot) {
    let data = document.data() ?? ["name": ""]
    profile.userId = data["userId"] as? String ?? ""
    profile.name = data["name"] as? String ?? ""
    profile.email = data["email"] as? String ?? ""
    profile.favourites = data["favourites"] as? [String] ?? []
    let msgs = data["chat"] as? [[String: String]] ?? []

    let oldPictureFileName = profile.pictureFileName
    profile.pictureFileName = data["pictureFileName"] as? String ?? ""
    if oldPictureFileName != profile.pictureFileName {
        let picture = Storage.storage()
            .reference()
            .child("\(userID)/\(profile.pictureFileName)")
        picture.getData(maxSize: 128 * 1024 * 1024) { data, error in
            if let _ = error {
                profile.picture = UIImage(named: "unknown")
            } else {
                profile.picture = UIImage(data: data!) ?? UIImage(named: "unknown")
            }
        }
    }
    profile.friendIDs = data["friends"] as? [String] ?? []
    profile.friendRequests = data["friendRequests"] as? [String] ?? []
    let results = data["gameResults"] as? [[String : Any]] ?? []
    profile.gameResults = []
    for result in results {
        let gameResult = GameResult(
            date: result["date"] as? Int ?? 0,
            gameType: result["gameType"] as? String ?? "Error",
            points: result["points"] as? Int ?? 0
        )
        profile.gameResults.append(gameResult)
    }
}

func loadProfile(userID: String, profile: Profile, andFriends: Bool = false) {
    Firestore.firestore()
        .collection("users")
        .document(userID)
        .getDocument { document, error in
            if let document = document, document.exists {
                loadProfileFromDocument(userID: userID, profile: profile, document: document)
                if andFriends {
                    print("A por los amigos \(profile.friendIDs)")
                    profile.friends = []
                    for friendID in profile.friendIDs.filter({$0 != ""}) {
                        let friendProfile = Profile()
                        loadProfile(userID: friendID, profile: friendProfile, andFriends: false)
                        profile.friends.append(friendProfile)
                    }
                }
                profile.show()
            }
        }
}

