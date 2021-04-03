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
    
    var body: some View {
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
                if possibleFriendUserId != "" { //TODO: Solo añadir si no es un amigo ya
                    sendFriendRequest(destinationId: possibleFriendUserId, profile: profile) { error in } // TODO: Tratamiento del error
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
                        if profile.friendIDs.contains(possibleFriendUserId) || profile.email == newEmail {
                            notValidEmail = true
                        }
                    }
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
