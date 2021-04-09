//
//  FindPeopleView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 27/3/21.
//

import SwiftUI

struct FindPeopleView: View {
    @EnvironmentObject var profile: Profile
    @State var foundFriends: [Profile] = []
    @State var dummy: [String] = []
    
    var body: some View {
        VStack {
            if foundFriends.count > 0 {
            List {
                ForEach (foundFriends, id: \.self.email) { friend in
                    NavigationLink(destination: FriendProfileView(friendProfile: friend, showFriendRequestButton: true, notifications: $dummy)){
                        HStack {
                            Image(uiImage: friend.picture ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            Text("\(friend.name)")
                            Spacer()
                        }
                    }
                }
            }
            } else {
                Text("We haven't found anybody with common favourite Hidden Women.")
                    .font(.title)
                    .padding()
            }
        }
        .onAppear{
            profile.getPeopleWithSimilarInterests(
                onError: { error in
                    print("DEBUG: LISTA VACIA!!!")
                }
            ) { snapshot in
                var buffer: [String: Profile] = [:]
                let maxPossibleFriends = 10
                
                for i in (0..<snapshot.documents.count).shuffled() {
                    let document = snapshot.documents[i]
                    let possibleFriendID = document.documentID
                    if (possibleFriendID != profile.userId &&
                            !profile.friends.map({$0.userId}).contains(possibleFriendID) &&
                            !profile.friendRequests.contains(possibleFriendID)
                    ) {
                        let possibleFriendProfile = Profile(userId: possibleFriendID)
                        possibleFriendProfile.from(document: document, rankingUpdater: RankingUpdater())
                        buffer[possibleFriendID] = possibleFriendProfile
                        if buffer.count >= maxPossibleFriends {
                            break
                        }
                    }
                }
                foundFriends = []
                for selectedPossibleFriendProfile in buffer.values.sorted(by: {$0.name < $1.name}) {
                    foundFriends.append(selectedPossibleFriendProfile)
                    selectedPossibleFriendProfile.getPicture {
                        foundFriends[0] = foundFriends[0] // TODO: actualizar lista
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
