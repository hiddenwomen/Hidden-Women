//
//  ResetPasswordView.swift
//  Hidden Women
//
//  Created by Claudia Marzal on 2021-03-13.
//

import SwiftUI
import Firebase

struct ResetPasswordView: View {
    @Binding var currentPage: Page
    @State var showBanner: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var emailForReset: String = ""
    
    
    var body: some View {
        ZStack {
        VStack {
            Text("Reset password")
                .font(.largeTitle)
            Image("logo_nombre")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            Text("If you tap on the 'Reset Password' button, your password will be reset. We will send an email to")
                .multilineTextAlignment(.leading)
                .padding()
            HStack {
                Image(systemName: "envelope")
                TextField("Email...", text: $emailForReset)
            }
            .frame(height: 60)
            .padding(.horizontal, 20)
            .background(Color("Hueso"))
            .cornerRadius(16)
            .padding(.horizontal, 20)
            Text("with instructions on how to reset your password.")
            Button(action: {
                resetPassword(
                    withEmail: emailForReset,
                    onError: { error in
                        errorMessage = error.localizedDescription
                        showError = true
                    },
                    onCompletion: {
                        showBanner = true
                    })
            }) {
                Text("Reset password")
                    .fontWeight(.bold)
                    .importantButtonStyle()
            }
            .padding()
            Button(action: {
                currentPage = .login
            }) {
                Text("Cancel")
                    .foregroundColor(Color("Morado"))
            }
            .padding()
            Spacer()
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
            if showBanner {
                BannerView(title: "Email sent", text: "An email has been sent with instructions on how to reset your password") {
                    showBanner = false
                    currentPage = .login
                }
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    @State static var currentPage: Page = .resetPassword
    
    static var previews: some View {
        ResetPasswordView(currentPage: $currentPage)
    }
}
