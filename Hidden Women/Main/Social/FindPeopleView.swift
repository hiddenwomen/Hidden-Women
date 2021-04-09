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
            List {
                ForEach (foundFriends, id: \.self.email) { friend in
                    NavigationLink(destination: FriendProfileView(friendProfile: friend, showFriendRequestButton: true, notifications: $dummy)){
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
            ) { snapshot in // TODO: Esto de aquí tiene pinta de ser muy mejorable
                var buffer: [String: Profile] = [:]
                for document in snapshot.documents {
                    let possibleFriendID = document.documentID
                    if possibleFriendID != profile.userId && !profile.friends.map({$0.userId}).contains(possibleFriendID) {
                        let possibleFriendProfile = Profile(userId: possibleFriendID)
                        possibleFriendProfile.from(document: document, rankingUpdater: RankingUpdater()) //TODO: Ojo con el rankingUpdater
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
