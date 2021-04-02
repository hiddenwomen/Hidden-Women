//
//  FindPeopleView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 27/3/21.
//

import SwiftUI
import Firebase

struct FindPeopleView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage("userID") var userID: String = ""
    @State var foundFriends: [Profile] = []
    
    var body: some View {
        VStack {
            ForEach (foundFriends, id: \.self.email) { friend in
                NavigationLink(destination: FriendProfileView(friendProfile: friend)){
                    HStack {
                        Image(uiImage: friend.picture ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 100)
                        Text("\(friend.name)")
                        Spacer()
                    }
                }
            }
        }
        .onAppear{
            print("Hola")
            Firestore.firestore()
                .collection("users")
                .whereField("favourites", arrayContainsAny: profile.favourites)
                .getDocuments() { snapshot, error in
                    if let snapshot = snapshot{
                        var buffer: [String: Profile] = [:]
                        for document in snapshot.documents {
                            let friendId = document.documentID
                            let data = document.data()
                            let friendProfile = Profile(
                                name: data["name"] as? String ?? "error",
                                email: data["email"] as? String ?? "error",
                                favourites: data["favourites"] as? [String] ?? [],
                                gameResults: []
                            )
                            let results = data["gameResults"] as? [[String : Any]] ?? []
                            friendProfile.gameResults = []
                            for result in results {
                                let gameResult = GameResult(
                                    date: result["date"] as? Int ?? 0,
                                    gameType: result["gameType"] as? String ?? "Error",
                                    points: result["points"] as? Int ?? 0
                                )
                                friendProfile.gameResults.append(gameResult)
                            }

                            if friendId != userID && !profile.friendIDs.contains(friendId) {
                                buffer[friendId] = friendProfile
                            }
                        }
                        foundFriends = []
                        for friend in buffer.keys.shuffled()[0..<min(buffer.count, 10)] {
                            foundFriends.append(buffer[friend]!)
                            let picture = Storage.storage().reference().child("\(friend)/Profile.png")
                            picture.getData(maxSize: 128 * 1024 * 1024) { data, error in
                                if let _ = error {
                                    buffer[friend]!.picture = UIImage(named: "unknown")
                                    print("NO ENCONTRADA FOTO DE \(friend)")
                                } else {
                                    buffer[friend]!.picture = UIImage(data: data!) ?? UIImage(named: "unknown")
                                    foundFriends[0] = foundFriends[0]
                                    print("ENCONTRADA FOTO DE \(friend)")
                                }
                            }
                        }
                    }
                }
        }
    }
}

struct FindPeopleView_Previews: PreviewProvider {
    static var previews: some View {
        FindPeopleView()
    }
}
