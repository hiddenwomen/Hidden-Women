//
//  LoginView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/3/21.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @AppStorage ("userID") var userID = ""
    
    @Binding var currentPage: Page
    @State var email = ""
    @State var password = ""
    @State var showErrorAlert = false
    @State var errorMessage = ""
    
    var body: some View {
        VStack {
            TextField("Email...", text: $email)
            SecureField("Password...", text: $password)
            Button(action: signin) {
                Text("Sign in")
            }
            Button(action: {currentPage = .signup}) {
                Text("Sign up")
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Sign in error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func signin() {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            } else {
                userID = user?.user.uid ?? ""
                currentPage = .main
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
