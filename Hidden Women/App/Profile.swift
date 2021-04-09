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
    var mainListener: ListenerRegistration? = nil

    var points: Int {
        let limit = Int(Date().timeIntervalSince1970) - oneWeek
        return gameResults.points(limit: limit)
    }
    
    var isGuest: Bool {
        return userId == ""
    }
    
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
        for friend in friends {
            friend.clear()
        }
        friends = []
        gameResults = []
        friendRequests = []
        
        if mainListener != nil {
            mainListener?.remove()
            mainListener = nil
        }
    }
    
    func toDict() -> [String: Any] {
        return [
            "userId": userId,
            "name": name,
            "email": email,
            "favourites": favourites,
            "pictureFileName": pictureFileName,
            "friends": friends.map{$0.userId},
            "gameResults": gameResults.map{$0.toDict()},
            "friendRequests": friendRequests
        ]
    }
    
    func from(document: DocumentSnapshot, rankingUpdater: RankingUpdater, andFriends: Bool = false) {
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
        self.friends = []

        if oldPictureFileName != self.pictureFileName {
            let picture = Storage.storage()
                .reference()
                .child("\(userId)/\(pictureFileName)")
            picture.getData(maxSize: 128 * 1024 * 1024) { data, error in // TODO: tamaño a constante
                if let _ = error {
                    self.picture = UIImage(named: "unknown")
                } else {
                    self.picture = UIImage(data: data!) ?? UIImage(named: "unknown")
                }
            }
        }
        
        if andFriends {
            let listOfFriends: Set<String> = Set(data["friends"] as? [String] ?? [])
            self.friends = Array(listOfFriends.map { friendID in
                let friendProfile = Profile(userId: friendID)
                friendProfile.load(rankingUpdater: rankingUpdater, andFriends: false)
                friendProfile.listen(rankingUpdater: rankingUpdater)
                return friendProfile
            })
        }

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
        print("--- desde acceptFriendRequest")
        let friendProfile = Profile(userId: friendUserId)
        friendProfile.load(rankingUpdater: rankingUpdater)
        friendProfile.listen(rankingUpdater: rankingUpdater)
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
    
//    func removeFriendListeners() {
//        if mainListener != nil {
//            mainListener?.remove()
//            mainListener = nil
//            print("*** Desconecto el listener principal")
//        }
//        for listener in friendListeners.values {
//            listener.remove()
//            print("*** Desconecto el listener de una amiga")
//        }
//        friendListeners = [:]
//    }
//
    func load(rankingUpdater: RankingUpdater, andFriends: Bool = false) {
        print("!!! loadProfile \(userId)")
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .getDocument { document, error in
                if let document = document, document.exists {
                    self.from(document: document, rankingUpdater: rankingUpdater, andFriends: andFriends)
                }
            }
    }

    func listen(rankingUpdater: RankingUpdater, andFriends: Bool = false) {
        print("!!! Fijo un escuchador para \(userId)")
        mainListener = Firestore.firestore()
            .collection("users")
            .document(userId)
            .addSnapshotListener { document, error in
                if let error = error {
                    print("Error fetching document: \(error)")
                    return
                } else if let _ = document {
                    print("--- desde listenToAndUpdateProfile")
                    self.load(rankingUpdater: rankingUpdater, andFriends: andFriends) // TODO: Repensar carga de amigos: loadFriendsProfiles
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



