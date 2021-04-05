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
                            if profile.friendIDs.contains(possibleFriendUserId) || profile.email == newEmail {
                                notValidEmail = true
                            }
                        }
                    }
                }
            }
            if showBanner {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Friend request sent")
                                .bold()
                            Text("The user can accept of reject your request.")
                                .font(Font.system(size: 15))
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(Color("Morado"))
                    .cornerRadius(8)
                    Spacer()
                }
                .padding()
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        showBanner = false
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            showBanner = false
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
