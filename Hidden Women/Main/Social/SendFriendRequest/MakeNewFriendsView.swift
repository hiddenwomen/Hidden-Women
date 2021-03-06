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
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Email...", text: $email)
                        .keyboardType(.emailAddress)
                }
                .frame(height: 60)
                .padding(.horizontal, 20)
                .background(Color("Hueso"))
                .cornerRadius(16)
                .padding()
                
                Button(action: {
                    if possibleFriendUserId != "" {
                        profile.sendFriendRequest(destinationId: possibleFriendUserId) { error in } // TODO: Tratamiento del error
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
                            if profile.friendProfiles.map({$0.userId}).contains(possibleFriendUserId) || profile.email == newEmail {
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
