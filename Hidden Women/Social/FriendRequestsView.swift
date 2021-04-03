//
//  FriendRequestsView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 28/3/21.
//

import SwiftUI

struct FriendRequestsView: View {
    @AppStorage("userID") var userID: String = ""
    @EnvironmentObject var profile: Profile
    
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
                                getProfile(forEmail: friendRequest, onError: { error in }) { document in
                                    let data = document.data() ?? ["userId": ""]
                                    let friendUserId = data["userId"] as? String ?? ""
                                    if friendUserId != "" {
                                        profile.friendRequests = profile.friendRequests.filter{$0 != friendRequest}
                                        updateFriendRequestForAcceptance(userID: userID, friendRequest: friendRequest, friendUserId: friendUserId)
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
                                profile.friendRequests = profile.friendRequests.filter{$0 != friendRequest}
                                updateProfileToRemoveFriendRequest(userID: userID, friendRequest: friendRequest)
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
