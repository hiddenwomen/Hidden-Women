//
//  FindPeopleView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 27/3/21.
//

import SwiftUI

struct FindPeopleView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage("userID") var userID: String = ""
    @State var foundFriends: [Profile] = []
    
    var body: some View {
        VStack {
            List {
                ForEach (foundFriends, id: \.self.email) { friend in
                    NavigationLink(destination: FriendProfileView(friendProfile: friend, showFriendRequestButton: true)){
                        HStack {
                            Image(uiImage: friend.picture ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                            Text("\(friend.name)")
                            Spacer()
                        }
                    }
                }
            }
        }
        .onAppear{
            profile.getPeopleWithSimilarInterests(
                onError: { error in
                    print("DEBUG: LISTA VACIA!!!")
                }
            ) { snapshot in
                var buffer: [String: Profile] = [:]
                for document in snapshot.documents {
                    let possibleFriendID = document.documentID
                    let data = document.data()
                    let possibleFriendProfile = Profile(
                        name: data["name"] as? String ?? "error",
                        email: data["email"] as? String ?? "error",
                        favourites: data["favourites"] as? [String] ?? [],
                        pictureFileName: data["pictureFileName"] as? String ?? "",
                        gameResults: []
                    )
                    let results = data["gameResults"] as? [[String : Any]] ?? []
                    possibleFriendProfile.gameResults = []
                    for result in results {
                        let gameResult = GameResult(
                            date: result["date"] as? Int ?? 0,
                            gameType: result["gameType"] as? String ?? "Error",
                            points: result["points"] as? Int ?? 0
                        )
                        possibleFriendProfile.gameResults.append(gameResult)
                    }
                    
                    if possibleFriendID != userID && !profile.friends.map({$0.userId}).contains(possibleFriendID) {
                        buffer[possibleFriendID] = possibleFriendProfile
                    }
                }
                foundFriends = []
                for selectedPossibleFriendID in buffer.keys.shuffled()[0..<min(buffer.count, 10)] {
                    let selectedPossibleFriendProfile = buffer[selectedPossibleFriendID]!
                    foundFriends.append(selectedPossibleFriendProfile)
                    selectedPossibleFriendProfile.getPicture {
                        foundFriends[0] = foundFriends[0] // TODO: Cochinada
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
