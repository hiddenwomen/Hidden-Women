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
    @Published var friendIDs: [String] = []
    @Published var friends: [Profile] = []
    @Published var gameResults: [GameResult] = []
    @Published var friendRequests: [String] = []
    var points: Int {
        let limit = Int(Date().timeIntervalSince1970) - oneWeek
        print("LIMITE \(limit) ::: \(gameResults)")
        return gameResults.filter{$0.date > limit}.map{$0.points}.reduce(0, +)
    }
    var id: UUID = UUID()
    
    init(name: String = "", email: String = "") {
        self.name = name
        self.email = email
    }
}

struct GameResult: Identifiable {
    let date: Int
    let gameType: String
    let points: Int
    let id: UUID = UUID()
}

func loadProfile(userID: String, profile: Profile, andFriends: Bool = false) {
    Firestore.firestore().collection("users").document(userID).getDocument { snapshot, e in
        if let snapshot = snapshot, snapshot.exists {
            let data = snapshot.data() ?? ["name": ""]
            profile.name = data["name"] as? String ?? ""
            profile.email = data["email"] as? String ?? ""
            profile.favourites = data["favourites"] as? [String] ?? []
            profile.friendIDs = data["friends"] as? [String] ?? []
            profile.friendRequests = data["friendRequests"] as? [String] ?? []
            let results = data["gameResults"] as? [[String : Any]] ?? []
            for result in results {
                let gameResult = GameResult(
                    date: result["date"] as? Int ?? 0,
                    gameType: result["gameType"] as? String ?? "Error",
                    points: result["points"] as? Int ?? 0
                )
                profile.gameResults.append(gameResult)
            }
            print("He cargado \(profile.email)")
            print("He cargado los puntos \(profile.gameResults)")
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
