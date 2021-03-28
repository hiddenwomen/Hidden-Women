//
//  FriendRequestsView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 28/3/21.
//

import SwiftUI
import Firebase

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
                                Firestore.firestore()
                                    .collection("emails")
                                    .document(friendRequest.lowercased())
                                    .getDocument { document, error in
                                        if let document = document {
                                            let data = document.data() ?? ["userId": ""]
                                            let friendUserId = data["userId"] as? String ?? ""
                                            print("FRIEND \(friendRequest) USERID \(friendUserId)")
                                            if friendUserId != "" {
                                                profile.friendRequests = profile.friendRequests.filter{$0 != friendRequest}
                                                Firestore.firestore()
                                                    .collection("users")
                                                    .document(userID)
                                                    .updateData([
                                                        "friendRequests": FieldValue.arrayRemove([friendRequest]),
                                                        "friends": FieldValue.arrayUnion([friendUserId])
                                                    ])
                                                Firestore.firestore()
                                                    .collection("users")
                                                    .document(friendUserId)
                                                    .updateData([
                                                        "friends": FieldValue.arrayUnion([userID])
                                                    ])
                                            }
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
                                Firestore.firestore()
                                    .collection("users")
                                    .document(userID)
                                    .updateData([
                                        "friendRequests": FieldValue.arrayRemove([friendRequest])
                                    ])
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
