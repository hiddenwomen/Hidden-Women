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

struct GameResult: Identifiable {
    let date: Int
    let gameType: String
    let points: Int
    let id: UUID = UUID()
    
    func toDict() -> [String: Any] {
        return [
            "date": date,
            "gameType": gameType,
            "points": points
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
    @Published var friends: [Profile] = []
    @Published var gameResults: [GameResult] = []
    @Published var friendRequests: [String] = []
    var friendListeners: [String: ListenerRegistration] = [:]
    
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
    
    func from(document: DocumentSnapshot, rankingUpdater: RankingUpdater, andFriends: Bool = false) {
        let data = document.data() ?? ["name": ""]
        self.userId = data["userId"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.favourites = data["favourites"] as? [String] ?? []
        
        let oldPictureFileName = self.pictureFileName
        self.pictureFileName = data["pictureFileName"] as? String ?? ""
        if oldPictureFileName != self.pictureFileName {
            let picture = Storage.storage()
                .reference()
                .child("\(userId)/\(pictureFileName)")
            picture.getData(maxSize: 128 * 1024 * 1024) { data, error in
                if let _ = error {
                    self.picture = UIImage(named: "unknown")
                } else {
                    self.picture = UIImage(data: data!) ?? UIImage(named: "unknown")
                }
            }
        }
        
        if andFriends {
            let listOfFriends = data["friends"] as? [String] ?? []
            for friendUserId in listOfFriends {
                if !self.friends.map({$0.userId}).contains(friendUserId) {
                    let friendProfile = Profile()
                    print("--- desde from")
                    loadProfile(userID: friendUserId, profile: friendProfile, rankingUpdater: rankingUpdater, andFriends: false)
                    self.friends.append(friendProfile)
                    self.friendListeners[friendUserId] = listenToAndUpdateProfile(userID: friendUserId, profile: friendProfile, rankingUpdater: rankingUpdater)
                }
            }
        }
        self.friendRequests = data["friendRequests"] as? [String] ?? []
        let oldResultsCount = self.gameResults.count
        let results = data["gameResults"] as? [[String : Any]] ?? []
        var theGameResults: [GameResult] = []
        for result in results {
            theGameResults.append(GameResult(
                date: result["date"] as? Int ?? 0,
                gameType: result["gameType"] as? String ?? "Error",
                points: result["points"] as? Int ?? 0
            ))
        }
        self.gameResults = theGameResults
        if oldResultsCount != self.gameResults.count {
            rankingUpdater.change()
        }
    }
    
    
    func updateGameResults(withNewGameResult: GameResult, onError: @escaping (Error) -> Void) {
        gameResults.append(withNewGameResult)
        print("!!! Grabo por updateGameResults")
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .updateData([
                "gameResults": FieldValue.arrayUnion([withNewGameResult.toDict()])
            ]) {
                error in
                if let error = error {
                    onError(error)
                }
            }
    }
    
    func getPicture(onCompletion: @escaping () -> Void) {
        let reference = Storage.storage().reference().child("\(userId)/\(pictureFileName)")
        reference.getData(maxSize: 128 * 1024 * 1024) { data, error in //TODO: Eso de 128*... huele mal
            if let _ = error {
                self.picture = UIImage(named: "unknown")
            } else {
                self.picture = UIImage(data: data!) ?? UIImage(named: "unknown")
                onCompletion()
            }
        }
        
    }
    
    func updatePicture(newPicture: UIImage?, onError: @escaping (Error) -> Void) {
        picture = newPicture?.scalePreservingAspectRatio(targetSize: CGSize(width: 200.0, height: 200.0))
        let pictureData = picture?.jpegData(compressionQuality: 0.9) ?? Data()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        let newFileName = "\(UUID()).jpg"
        Storage.storage().reference().child("\(userId)/\(newFileName)").putData(pictureData, metadata: metadata) { metadata, error in
            if let error = error {
                onError(error)
            } else {
                print("!!! Grabo por updatePicture")
                self.pictureFileName = newFileName
                Firestore.firestore()
                    .collection("users")
                    .document(self.userId)
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
    
    func updateName(name: String, onError: @escaping (Error) -> Void) {
        print("!!! Grabo por updateName")
        self.name = name
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .updateData(["name": name]) { error in
                if let error = error {
                    onError(error)
                }
            }
    }
    
    
    func acceptFriendRequest(friendRequest: String, friendUserId: String, rankingUpdater: RankingUpdater) {
        friendRequests = friendRequests.filter{$0 != friendRequest} //TODO: EL listener puede que haga esto mismo gratis tras ejecutar la siguiente llamada a Firestore
        print("!!! Grabo por acceptFriendRequest (en \(userId) y en \(friendUserId))")
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .updateData([
                "friendRequests": FieldValue.arrayRemove([friendRequest]),
                "friends": FieldValue.arrayUnion([friendUserId])
            ])
        Firestore.firestore()
            .collection("users")
            .document(friendUserId)
            .updateData([
                "friends": FieldValue.arrayUnion([userId])
            ])
        let friendProfile = Profile()
        print("--- desde acceptFriendRequest")
        loadProfile(userID: friendUserId, profile: friendProfile, rankingUpdater: rankingUpdater)
        friendListeners[friendUserId] = listenToAndUpdateProfile(userID: friendUserId, profile: friendProfile, rankingUpdater: rankingUpdater)
        self.friends.append(friendProfile)
    }
    
    func rejectFriendRequest(friendRequest: String) {
        friendRequests = friendRequests.filter{$0 != friendRequest} //TODO: ver todo de arriba.
        print("!!! Grabo por rejectFriendRequest")
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .updateData([
                "friendRequests": FieldValue.arrayRemove([friendRequest])
            ])
    }
    
    
    func updateFavourites(onError: @escaping (Error) -> Void) {
        print("!!! Grabo por updateFavourites")
        Firestore.firestore().collection("users").document(userId).updateData(
            ["favourites": self.favourites]
        ) { error in
            if let error = error {
                onError(error)
            }
        }
    }
    
    func getPeopleWithSimilarInterests(onError: @escaping (Error) -> Void, onCompletion: @escaping (QuerySnapshot) -> Void) {
        if favourites.count > 0 {
            print("!!! leo por getPeopleWithSimilarInterests")
            Firestore.firestore()
                .collection("users")
                .whereField("favourites", arrayContainsAny: self.favourites)
                .getDocuments() { snapshot, error in
                    if let error = error {
                        onError(error)
                    } else if let document = snapshot {
                        onCompletion(document)
                    }
                }
        }
    }
    
    func removeListeners() {
        if mainListener != nil {
            mainListener?.remove()
            mainListener = nil
            print("*** Desconecto el listener principal")
        }
        for listener in friendListeners.values {
            listener.remove()
            print("*** Desconecto el listener de una amiga")
        }
        friendListeners = [:]
    }
}



// Friend-related functions

func getUserId(forEmail: String, onError: @escaping (Error) -> Void, onCompletion: @escaping (DocumentSnapshot) -> Void) {
    print("!!! leo por getUserId")
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

func sendFriendRequest(destinationId: String, withMyProfile: Profile, onError: @escaping (Error) -> Void) {
    print("!!! Grabo por sendFriendRequest")
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
                    print("!!! Grabo datos por signIn tras creación de usuario")
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

func listenToAndUpdateProfile(userID: String, profile: Profile, rankingUpdater: RankingUpdater, andFriends: Bool = false) -> ListenerRegistration {
    print("!!! Fijo un escuchador para \(userID)")
    return Firestore.firestore()
        .collection("users")
        .document(userID)
        .addSnapshotListener { document, error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            } else if let _ = document {
                print("--- desde listenToAndUpdateProfile")
                loadProfile(userID: userID, profile: profile, rankingUpdater: rankingUpdater, andFriends: andFriends) // TODO: Repensar carga de amigos: loadFriendsProfiles
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

func setLastAccesToChat(aId: String, bId: String, toId: String, onError: @escaping (Error) -> Void) {
    let key: String = aId < bId ? "\(aId)::\(bId)" : "\(bId)::\(aId)"
    let now: Int = Int(Date().timeIntervalSince1970)
    let data: [String: Int] = [ toId: now ]
    Firestore.firestore()
        .collection("chats")
        .document(key)
        .updateData(data) { error in
            if let error = error {
                onError(error)
            }
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
    print("!!! Fijo un escuchador para chat \(key)")
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
    print("!!! Grabo chat \(key)")
    
    let reference  =  Firestore.firestore().collection("chats").document(key)
    reference.getDocument() { documentSnapshot, error in
        if let error = error {
            onError(error)
        } else if let documentSnapshot = documentSnapshot {
            if documentSnapshot.exists {
                print("!!! Grabo por sendChatMessage (1)")
                reference
                    .updateData([
                        "messages": FieldValue.arrayUnion([message.toDict()])
                    ]) { error in
                        if let error = error {
                            onError(error)
                        }
                    }
            } else {
                print("!!! Grabo por sendChatMessage (2)")
                reference.setData([
                    aId: 0,
                    bId: 0,
                    "messages": [
                        message.toDict()
                    ],
                    "participants": [
                        aId, bId
                    ]
                ])
            }
        }
    }
    
}


func loadProfile(userID: String, profile: Profile, rankingUpdater: RankingUpdater, andFriends: Bool = false) {
    print("!!! loadProfile \(userID)")
    Firestore.firestore()
        .collection("users")
        .document(userID)
        .getDocument { document, error in
            if let document = document, document.exists {
                profile.from(document: document, rankingUpdater: rankingUpdater, andFriends: andFriends)
            }
        }
}

func getChatNotifications(profile: Profile, notificationFrom: @escaping (String)-> Void) {
    Firestore.firestore()
        .collection("chats")
        .whereField(
            "participants",
            arrayContains: profile.userId
        )
        .getDocuments { querySnapshot, error in
            if let error = error {
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let data = document.data()
                    let dataMessages = data["messages"] as? [[String: String]] ?? []
                    if !dataMessages.isEmpty {
                        let lastMessageTime = Int(dataMessages.last!["time"] ?? "") ?? 0
                        let lastAccess = data[profile.userId] as? Int ?? 0
                        if lastAccess < lastMessageTime {
                            let participants = data["participants"] as? [String] ?? []
                            let friendId = participants.filter{$0 != profile.userId}.first ?? ""
                            if friendId != "" {
                                notificationFrom(friendId)
                            }
                        }
                    }
                    }

                }
            }
    }

