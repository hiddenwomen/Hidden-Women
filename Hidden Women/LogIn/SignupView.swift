//
//  SignupView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/3/21.
//

import SwiftUI

struct SignupView: View {
    @AppStorage ("userID") var userID = ""
    @EnvironmentObject var profile: Profile
    @EnvironmentObject var rankingUpdater: RankingUpdater
    
    @Binding var currentPage: Page
    
    @State var email = ""
    @State var password = ""
    @State var repeatedPassword = ""
    
    @State var showErrorAlert = false
    @State var errorMessage = ""
    
    var body: some View {
        ScrollView {
            VStack (spacing: 15){
                Image("logo_nombre")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                HStack {
                    Image(systemName: "envelope")
                    TextField("Email...", text: $email)
                        .keyboardType(.emailAddress)
                }
                .frame(height: 60)
                .padding(.horizontal, 20)
                .background(Color("Hueso"))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password...", text: $password)
                }
                .frame(height: 60)
                .padding(.horizontal, 20)
                .background(Color("Hueso"))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("Repeat password...", text: $repeatedPassword)
                }
                .frame(height: 60)
                .padding(.horizontal, 20)
                .background(Color("Hueso"))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                
                Button(action: {
                    if password == repeatedPassword {
                        signUp(
                            withEmail: email,
                            password: password,
                            profile: profile,
                            onError: { error in
                                errorMessage = error.localizedDescription
                                showErrorAlert = true
                            }) { authResult in
                            profile.clear()
                            userID = authResult.user.uid
                            profile.userId = userID
                            profile.listen(rankingUpdater: rankingUpdater) {
                                profile.friendProfiles = profile.friendProfiles.sorted(by: { $0.name < $1.name })
                            }
                            currentPage = .main
                        }
                    } else {
                        errorMessage = "Passwords do not match"
                        showErrorAlert = true
                    }
                }) {
                    Text("Sign up")
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40))
                        .foregroundColor(Color.white)
                        .background(Color("Morado"))
                        .cornerRadius(10)
                }
                HStack {
                    Text("Already have an account?")
                    Button(action: {currentPage = .login}) {
                        Text("Sign in")
                            .foregroundColor(Color("Morado"))
                    }
                }
                .alert(isPresented: $showErrorAlert) {
                    Alert(
                        title: Text("Sign up error"),
                        message: Text(errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                Spacer()
            }
        }
    }
    
}
struct SignupView_Previews: PreviewProvider {
    @State static var page: Page = .signup
    
    static var previews: some View {
        SignupView(currentPage: $page)
    }
}

