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
            List(profile.friends) { friend in
                NavigationLink(destination: FriendProfileView(friendProfile: friend, friendRequestButton: false)) {
                    HStack {
                        Image(uiImage: friend.picture ?? UIImage())
                            .resizable()
                            .scaledToFit()
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

struct MyFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        MyFriendsView()
    }
}
