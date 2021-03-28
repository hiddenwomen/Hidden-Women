//
//  MakeNewFriendsView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 27/3/21.
//

import SwiftUI
import Firebase

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
                    Firestore.firestore()
                        .collection("users")
                        .document(possibleFriendUserId)
                        .updateData([
                            "friendRequests": FieldValue.arrayUnion([profile.email])
                        ])
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
                Firestore.firestore()
                    .collection("emails")
                    .document(newEmail.lowercased())
                    .getDocument { document, error in
                        if let document = document {
                            notValidEmail = !document.exists
                            if document.exists {
                                let data = document.data() ?? ["userId": ""]
                                possibleFriendUserId = data["userId"] as? String ?? ""
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
