//
//  Profile.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 18/3/21.
//

import Foundation
import SwiftUI
import Firebase

class Profile: ObservableObject, Identifiable {
    @Published var name: String
    @Published var email: String
    @Published var favourites: [String] = []
    @Published var picture: UIImage? = UIImage(named: "unknown")
    @Published var friendIDs: [String] = []
    @Published var friends: [Profile] = []
    @Published var gameResults: [GameResult] = []
 
    var id: UUID = UUID()
    
    init(name: String = "", email: String = "") {
        self.name = name
        self.email = email
    }
}

struct GameResult {
    let gameType: String
    let points: Int
}

func loadProfile(userID: String, profile: Profile, andFriends: Bool = false) {
    Firestore.firestore().collection("users").document(userID).getDocument { snapshot, e in
        if let snapshot = snapshot, snapshot.exists {
            let data = snapshot.data() ?? ["name": ""]
            profile.name = data["name"] as? String ?? ""
            profile.email = data["email"] as? String ?? ""
            profile.favourites = data["favourites"] as? [String] ?? []
            profile.friendIDs = data["friends"] as? [String] ?? []
            print("He cargado \(profile.email)")
            if andFriends {
                for friendID in profile.friendIDs {
                    let friendProfile = Profile()
                    loadProfile(userID: friendID, profile: friendProfile, andFriends: false)
                    profile.friends.append(friendProfile)
                }
            }
        }
    }
    let picture = Storage.storage().reference().child("\(userID)/Profile.png")
    picture.getData(maxSize: 128 * 1024 * 1024) { data, error in
        if let _ = error {
            profile.picture = UIImage(named: "unknown")
        } else {
            profile.picture = UIImage(data: data!) ?? UIImage(named: "unknown")
        }
    }
}

func updateGameResults(profile: Profile) {
    
}
