//
//  SignupView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/3/21.
//

import SwiftUI
import Firebase

struct SignupView: View {
    @AppStorage ("userID") var userID = ""

    @Binding var currentPage: Page
    @State var email = ""
    @State var password = ""
    @State var repeatedPassword = ""
    @State var showErrorAlert = false
    @State var errorMessage = ""
    
    var body: some View {
        VStack {
            TextField("Email...", text: $email)
            SecureField("Password...", text: $password)
            SecureField("Repeat password...", text: $repeatedPassword)
            Button(action: signup) {
                Text("Sign up")
            }
            Button(action: {currentPage = .login}) {
                Text("Cancel")
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Sign up error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    func signup () {
        if password == repeatedPassword {
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                if let error = error {
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                } else {
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
            } else {
                errorMessage = "Passwords do not match"
                showErrorAlert = true
        
    }
}
}
    struct SignupView_Previews: PreviewProvider {
        @State static var page: Page = .signup
        
        static var previews: some View {
            SignupView(currentPage: $page)
        }
    }

