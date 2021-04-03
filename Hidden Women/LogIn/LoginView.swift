//
//  LoginView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/3/21.
//

import SwiftUI

struct LoginView: View {
    @AppStorage ("userID") var userID = ""
    @EnvironmentObject var profile: Profile
    @Binding var currentPage: Page
    
    @State var email = ""
    @State var password = ""
    @State var showErrorAlert = false
    @State var errorMessage = ""
    
    var body: some View {
        ScrollView {
            VStack (spacing: 15) {
                Image("logo_nombre")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                HStack {
                    Image(systemName: "envelope")
                    TextField("Email...", text: $email)
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
                Button(action: {currentPage = .resetPassword}) {
                    Text("Have you forgotten your password?")
                        .foregroundColor(Color("Morado"))
                        .font(.caption)
                }
                Button(action: {
                    signin(
                        withEmail: email,
                        password: password,
                        onError: { error in
                            errorMessage = error.localizedDescription
                            showErrorAlert = true
                        }) { authResult in
                            userID = authResult.user.uid
                            loadProfile(userID: userID, profile: profile, andFriends: true)
                            currentPage = .main
                        }
                }) {
                    Text("Sign in")
                        .fontWeight(.bold)
                        .importantButtonStyle()
                }
                .padding()
                HStack {
                    Text("Don't have an account?")
                    Button(action: {currentPage = .signup}) {
                        Text("Sign up")
                            .foregroundColor(Color("Morado"))
                    }
                }
                HStack {
                    Text("... or enter as a")
                    Button(action: {currentPage = .guest}) {
                        Text("guest")
                            .foregroundColor(Color("Morado"))
                    }
                }
                Spacer()
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Sign in error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    

}

struct LoginView_Previews: PreviewProvider {
    @State static var page: Page = .login
    
    static var previews: some View {
        LoginView(currentPage: $page)
    }
}
