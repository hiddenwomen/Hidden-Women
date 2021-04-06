//
//  MakeNewFriendsView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 27/3/21.
//

import SwiftUI

struct MakeNewFriendsView: View {
    @EnvironmentObject var profile: Profile
    @State var email: String = ""
    @State var notValidEmail: Bool = true
    @State var possibleFriendUserId: String = ""
    @State var showBanner: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Send a friend request")
                    .font(.title)
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Email...", text: $email)
                }
                .frame(height: 60)
                .padding(.horizontal, 20)
                .background(Color("Hueso"))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                
                Button(action: {
                    if possibleFriendUserId != "" {
                        sendFriendRequest(destinationId: possibleFriendUserId, withMyProfile: profile) { error in } // TODO: Tratamiento del error
                        showBanner = true
                    }
                } ){
                    Text("Send friend request")
                        .fontWeight(.bold)
                }
                .importantButtonStyle(notValidEmail ? .gray : Color("Morado"))
                .disabled(notValidEmail)
            }
            .onChange(of: email) { newEmail in
                if newEmail.isValidEmail() {
                    getUserId(forEmail: newEmail, onError: {error in }) { document in
                        notValidEmail = !document.exists
                        if document.exists {
                            let data = document.data() ?? ["userId": ""]
                            possibleFriendUserId = data["userId"] as? String ?? ""
                            if profile.friends.map({$0.userId}).contains(possibleFriendUserId) || profile.email == newEmail {
                                notValidEmail = true
                            }
                        }
                    }
                }
            }
            if showBanner {
                BannerView(
                    title: "Friend request sent",
                    text: "The user can accept of reject your request."
                ) {
                    showBanner = false
                }
            }
        }
    }
}

struct MakeNewFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        MakeNewFriendsView()
    }
}
