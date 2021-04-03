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
    
    init(name: String = "", email: String = "", favourites: [String] = [], pictureFileName: String = "Profile.png", gameResults: [GameResult] = []) {
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

func loadProfile(userID: String, profile: Profile, andFriends: Bool = false) {
    Firestore.firestore()
        .collection("users")
        .document(userID)
        .getDocument { snapshot, e in
            if let snapshot = snapshot, snapshot.exists {
                let data = snapshot.data() ?? ["name": ""]
                profile.name = data["name"] as? String ?? ""
                profile.email = data["email"] as? String ?? ""
                profile.favourites = data["favourites"] as? [String] ?? []
                let oldPictureFileName = profile.pictureFileName
                profile.pictureFileName = data["pictureFileName"] as? String ?? "Profile.png"
                print("DEBUG: EL VIEJO \(oldPictureFileName) Y EL NUEVO \(profile.pictureFileName) PARA \(profile.name)")
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

func sendFriendRequest(destinationId: String, profile: Profile, onError: @escaping (Error) -> Void) {
    Firestore.firestore()
        .collection("users")
        .document(destinationId)
        .updateData([
            "friendRequests": FieldValue.arrayUnion([profile.email])
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

func signin(withEmail: String, password: String, onError: @escaping (Error) -> Void, onCompletion: @escaping (AuthDataResult) -> Void) {
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
