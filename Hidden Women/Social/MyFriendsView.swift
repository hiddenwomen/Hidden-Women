//
//  MyFriendsView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 27/3/21.
//

import SwiftUI

struct MyFriendsView: View {
    @EnvironmentObject var profile: Profile
    
    var body: some View {
        VStack {
            Text("Friends")
                .font(.largeTitle)
                .padding()
            List {
                ForEach(profile.friends, id:\.self.userId) { friend in
                    NavigationLink(destination: FriendProfileView(friendProfile: friend, showFriendRequestButton: false)) {
                        HStack {
                            Image(uiImage: friend.picture ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 75, height: 75)
                            VStack(alignment: .leading) {
                                Text("\(friend.name)")
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MyFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        MyFriendsView()
    }
}
