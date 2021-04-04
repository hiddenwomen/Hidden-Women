//
//  ResetPasswordView.swift
//  Hidden Women
//
//  Created by Claudia Marzal on 2021-03-13.
//

import SwiftUI
import Firebase

struct ResetPasswordView: View {
    @EnvironmentObject var profile: Profile
    @Binding var currentPage: Page
    @State var showAlert: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""

    var body: some View {
        VStack {
            Text("If you tap on the 'Reset Password' button, your password will be reset.")
                .multilineTextAlignment(.center)
            Text("We will send you an email to")
            Text(profile.email)
            Text("with instructions on how to reset your password.")
            Button(action: {
                resetPassword(
                    withEmail: profile.email,
                    onError: { error in
                        errorMessage = error.localizedDescription
                        showError = true
                    },
                    onCompletion: {
                        showAlert = true
                    })
                currentPage = .login
            }) {
                Text("Reset password")
            }
            Button(action: {
                currentPage = .login
            }) {
                Text("Cancel")
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Email sent"),
                message: Text("Check you email and follow the instructions to reset your password."),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    @State static var currentPage: Page = .resetPassword
    static var previews: some View {
        ResetPasswordView(currentPage: $currentPage)
    }
}
