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
            List(profile.friends){ friend in
                HStack {
                    Image(uiImage: friend.picture ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 75, height: 75)
                    VStack(alignment: .leading) {
                        Text("\(friend.email)")
                            .fontWeight(.bold)
                        Text(
                            String.localizedStringWithFormat(NSLocalizedString("Points: %@", comment: ""), friend.points)
                        )
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
