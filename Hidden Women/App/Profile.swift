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
let maxImageSize: Int64 = 128 * 1024 * 1024

class Profile: ObservableObject, Identifiable {
    @Published var userId: String
    @Published var name: String
    @Published var email: String
    @Published var favourites: [String] = []
    @Published var picture: UIImage? = UIImage(named: "unknown")
    @Published var pictureFileName: String = ""
    @Published var friendProfiles: [Profile] = []
    @Published var friends: [String] = []
    @Published var gameResults: [GameResult] = []
    @Published var friendRequests: [String] = []
    var listener: ListenerRegistration? = nil
    
    var points: Int {
        let limit = Int(Date().timeIntervalSince1970) - oneWeek
        return gameResults.points(limit: limit)
    }
    
    var isGuest: Bool {
        return userId == ""
    }
    
    @AppStorage("userID") var mainUserID = ""
    var id: UUID = UUID()
    
    init(userId: String, name: String = "", email: String = "", favourites: [String] = [], pictureFileName: String = "", gameResults: [GameResult] = []) {
        self.userId = userId
        self.name = name
        self.email = email
        self.favourites = favourites
        self.pictureFileName = pictureFileName
        self.gameResults = gameResults
    }
    
    func clear() {
        userId = ""
        name = ""
        email = ""
        favourites = []
        picture = UIImage(named: "unknown")
        pictureFileName = ""
        for friend in friendProfiles {
            friend.clear()
        }
        friendProfiles = []
        friends = []
        gameResults = []
        friendRequests = []
        
        if listener != nil {
            listener?.remove()
            listener = nil
        }
    }
    
    func toDict() -> [String: Any] {
        return [
            "userId": userId,
            "name": name,
            "email": email,
            "favourites": favourites,
            "pictureFileName": pictureFileName,
            "friends": friends,
            "gameResults": gameResults.map{$0.toDict()},
            "friendRequests": friendRequests,
        ]
    }
    
    func from(document: DocumentSnapshot, rankingUpdater: RankingUpdater) {
        let oldPictureFileName = self.pictureFileName
        let oldResultsCount = self.gameResults.count
        
        let data = document.data() ?? ["name": ""]
        
        self.userId = data["userId"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.favourites = data["favourites"] as? [String] ?? []
        self.pictureFileName = data["pictureFileName"] as? String ?? ""
        self.gameResults = (data["gameResults"] as? [[String: Any]] ?? []).map {GameResult.from(dict: $0)}
        self.friendRequests = data["friendRequests"] as? [String] ?? []
        self.friends = data["friends"] as? [String] ?? []
        
        if oldResultsCount != self.gameResults.count {
            rankingUpdater.change()
        }
        
        if oldPictureFileName != self.pictureFileName {
            let picture = Storage.storage()
                .reference()
                .child("\(userId)/\(pictureFileName)")
            picture.getData(maxSize: maxImageSize) { data, error in // TODO: tamaño a constante
                if let _ = error {
                    self.picture = UIImage(named: "unknown")
                } else {
                    self.picture = UIImage(data: data!) ?? UIImage(named: "unknown")
                }
            }
        }
        
        print("XXXXX2 \(self.userId) -> \(self.friendProfiles)")
    }
    
    func load(rankingUpdater: RankingUpdater, onCompletion: @escaping () -> Void) {
        print("!!! loadProfile \(userId)")
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .getDocument { document, error in
                if let document = document, document.exists {
                    self.from(document: document, rankingUpdater: rankingUpdater)
                    print("Data from user \(self.userId) loaded")
                    if self.userId == self.mainUserID {
                        let knownFriends = Set(self.friendProfiles.map{$0.userId}.filter{$0 != ""})
                        for friendID in self.friends.filter({ $0 != "" && !knownFriends.contains($0) }) {
                            print("***** CARGANDO \(friendID)")
                            let friendProfile = Profile(userId: friendID)
                            friendProfile.load(rankingUpdater: rankingUpdater, onCompletion: onCompletion)
                            if self.friendProfiles.allSatisfy( { friendProfile.userId != $0.userId } ) {
                                friendProfile.listen(rankingUpdater: rankingUpdater, onCompletion: onCompletion)
                                self.friendProfiles.append(friendProfile)
                            }
                        }
                    }
                    print("XXXXX1 \(self.userId) -> \(self.friendProfiles)")
                }
            }
    }
    
    func listen(rankingUpdater: RankingUpdater, onCompletion: @escaping () -> Void) {
        print("!!! Fijo un escuchador para \(userId)")
        listener = Firestore.firestore()
            .collection("users")
            .document(userId)
            .addSnapshotListener { document, error in
                if let error = error {
                    print("Error fetching document: \(error)")
                    return
                } else if let document = document {
                    print("--- desde listenToAndUpdateProfile:")
                    if self.userId == self.mainUserID {
                        let oldFriends = Set(self.friends)
                        self.from(document: document, rankingUpdater: rankingUpdater)
                        let newFriends = Set(self.friends)
                        if oldFriends != newFriends {
                            self.load(rankingUpdater: rankingUpdater, onCompletion: onCompletion)
                        }
                    }
                }
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
        reference.getData(maxSize: maxImageSize) { data, error in
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
        Storage.storage()
            .reference()
            .child("\(userId)/\(newFileName)")
            .putData(pictureData, metadata: metadata) { metadata, error in
                if let error = error {
                    onError(error)
                } else {
                    print("!!! Grabo por updatePicture")
                    let oldPictureFileName = self.pictureFileName
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
                    Storage.storage()
                        .reference()
                        .child("\(self.userId)/\(oldPictureFileName)")
                        .delete(completion: {error in
                            if let error = error {
                                onError(error)
                            }
                        })
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
        friendRequests = friendRequests.filter{$0 != friendRequest}
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
        print("--- desde acceptFriendRequest")
        let friendProfile = Profile(userId: friendUserId)
        friendProfile.load(rankingUpdater: rankingUpdater) {
            self.friendProfiles = self.friendProfiles.sorted(by: { $0.name < $1.name })
        }
        friendProfile.listen(rankingUpdater: rankingUpdater, onCompletion: {})
        self.friendProfiles.append(friendProfile)
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
    
    func getChatNotifications(notificationFrom: @escaping (String)-> Void) {
        Firestore.firestore()
            .collection("chats")
            .whereField("participants", arrayContains: self.userId)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    // TODO: Tratamiento de error
                } else if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        let data = document.data()
                        let dataMessages = data["messages"] as? [[String: String]] ?? []
                        if !dataMessages.isEmpty {
                            let lastMessageTime = Int(dataMessages.last!["time"] ?? "") ?? 0
                            let lastAccess = data[self.userId] as? Int ?? 0
                            if lastAccess < lastMessageTime {
                                let participants = data["participants"] as? [String] ?? []
                                let friendId = participants.filter{$0 != self.userId}.first ?? ""
                                if friendId != "" {
                                    notificationFrom(friendId)
                                }
                            }
                        }
                    }
                    
                }
            }
    }
    
    func sendFeedback(text: String, onError: @escaping (Error) -> Void) {
        let comment: [String: String] = [
            "userId": self.userId,
            "email": self.isGuest ? "Guest" : self.email,
            "date": String(Date().timeIntervalSince1970),
            "comment": text
        ]
        
        Firestore.firestore()
            .collection("comments")
            .document("comments")
            .updateData([
                "comments": FieldValue.arrayUnion([comment])
            ]) {
                error in
                if let error = error {
                    onError(error)
                }
            }
    }
    
    func sendFriendRequest(destinationId: String, onError: @escaping (Error) -> Void) {
        print("!!! Grabo por sendFriendRequest a \(destinationId) añadiendo \(self.email)")
        Firestore.firestore()
            .collection("users")
            .document(destinationId)
            .updateData([
                "friendRequests": FieldValue.arrayUnion([self.email])
            ]) { error in
                if let error = error {
                    onError(error)
                }
            }
    }
    
}



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
                    profile.clear()
                    let userID = authResult.user.uid
                    profile.name = withEmail.components(separatedBy: "@")[0]
                    profile.userId = userID
                    profile.email = withEmail
                    print("!!! Grabo datos por signIn tras creación de usuario")
                    Firestore.firestore()
                        .collection("users")
                        .document(userID)
                        .setData(profile.toDict()) { error in
                            if let error = error{
                                onError(error)
                            }
                        }
                    Firestore.firestore()
                        .collection("emails")
                        .document(profile.email.lowercased())
                        .setData(["userId": userID]) { error in
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



