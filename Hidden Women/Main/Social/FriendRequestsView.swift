//
//  FriendRequestsView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 28/3/21.
//

import SwiftUI

struct FriendRequestsView: View {
    @EnvironmentObject var profile: Profile
    @EnvironmentObject var rankingUpdater: RankingUpdater
    
    var body: some View {
        HStack {
            Text("Friend requests...")
                .font(.title)
        }
        Divider()
        ScrollView {
            VStack {
                ForEach(profile.friendRequests, id:\.self) { friendRequest in
                    VStack {
                        Text(friendRequest)
                            .fontWeight(.bold)
                        HStack {
                            Button(action:  {
                                getUserId(forEmail: friendRequest, onError: { error in }) { document in
                                    let data = document.data() ?? ["userId": ""]
                                    let friendUserId = data["userId"] as? String ?? ""
                                    if friendUserId != "" {
                                        profile.acceptFriendRequest(friendRequest: friendRequest, friendUserId: friendUserId, rankingUpdater: rankingUpdater)
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "person.fill.checkmark")
                                    Text("Accept")
                                        .fontWeight(.bold)
                                }
                            }
                            .importantButtonStyle()
                            Button(action:  {
                                profile.rejectFriendRequest(friendRequest: friendRequest)
                            }) {
                                HStack {
                                    Image(systemName: "person.fill.xmark")
                                    Text("Reject")
                                        .fontWeight(.bold)
                                }
                            }
                            .importantButtonStyle(Color("Turquesa"))
                        }
                    }
                    Divider()
                }
            }
        }
    }
}

struct ProcessFriendRequests_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestsView()
    }
}
