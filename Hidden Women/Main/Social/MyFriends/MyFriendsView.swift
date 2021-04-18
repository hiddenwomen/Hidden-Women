//
//  MyFriendsView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 27/3/21.
//

import SwiftUI

struct MyFriendsView: View {
    @EnvironmentObject var profile: Profile
    @State var notifications: [String] = []
    
    var body: some View {
        VStack {
            Text("Friends")
                .font(.largeTitle)
                .padding()
            List {
                ForEach(profile.friendProfiles, id:\.self.userId) { friend in
                    NavigationLink(destination: FriendProfileView(friendProfile: friend, showFriendRequestButton: false, notifications: $notifications)) {
                        HStack {
                            Image(uiImage: friend.picture ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 75)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text("\(friend.name)")
                                    .fontWeight(.bold)
                                if notifications.contains(friend.userId) {
                                    HStack {
                                        Image(systemName: "bubble.left.and.bubble.right.fill")
                                        Text("You have new messages")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Button(action: {
                profile.getChatNotifications(notificationFrom: { friendId in
                    notifications.append(friendId)
                })
                profile.friends = profile.friends.sorted(by: {$0 < $1})
            }) {
                Image(systemName: "arrow.clockwise")
                Text("Refresh")
            }
        }
        .onAppear {
            print("MY FRIENDs VIEW \(profile.friendProfiles)")
            profile.getChatNotifications(notificationFrom: { friendId in
                notifications.append(friendId)
            })
        }
    }
}
    

struct MyFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        MyFriendsView()
    }
}
