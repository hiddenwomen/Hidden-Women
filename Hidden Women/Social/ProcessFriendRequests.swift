//
//  ProcessFriendRequests.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 28/3/21.
//

import SwiftUI

struct ProcessFriendRequests: View {
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
                            Button(action:  {}) {
                                HStack {
                                    Image(systemName: "person.fill.checkmark")
                                    Text("Accept")
                                        .fontWeight(.bold)
                                }
                            }
                            .importantButtonStyle()
                            Button(action:  {}) {
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
        ProcessFriendRequests()
    }
}
