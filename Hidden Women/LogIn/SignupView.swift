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
        ScrollView {
            VStack (spacing: 15){
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
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("Repeat password...", text: $repeatedPassword)
                }
                .frame(height: 60)
                .padding(.horizontal, 20)
                .background(Color("Hueso"))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                
                Button(action: signup) {
                    Text("Sign up")
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40))
                        .foregroundColor(Color.white)
                        .background(Color("Morado"))
                        .cornerRadius(10)
                }
                Button(action: {currentPage = .login}) {
                    Text("Cancel")
                        .foregroundColor(Color("Morado"))
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

