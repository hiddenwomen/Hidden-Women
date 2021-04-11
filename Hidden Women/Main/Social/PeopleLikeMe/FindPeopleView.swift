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
    @State var alreadyTried: Bool = false
    @State var dummy: [String] = []

    var body: some View {
        VStack {
            Button(action: {
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
                    }
                }
                alreadyTried = true
            }) {
                Text("Find possible friends")
                    .bold()
                    .importantButtonStyle()
            }
            .padding()
            if foundFriends.count > 0 {
                List {
                    ForEach (foundFriends, id: \.self.email) { friend in
                        NavigationLink(
                            destination: FriendProfileView(
                                friendProfile: friend,
                                showFriendRequestButton: true,
                                notifications: $dummy
                            )
                        ){
                            FIndPeopleCardView(friendProfile: friend)
                        }
                    }
                }
            } else {
                if alreadyTried {
                    Text("We haven't found anybody with favourite Hidden Women in common with you.")
                        .font(.title)
                        .padding()
                }
            }
        }
        .onAppear {
            alreadyTried = false
        }
    }
}

struct FindPeopleView_Previews: PreviewProvider {
    static var previews: some View {
        FindPeopleView()
    }
}
