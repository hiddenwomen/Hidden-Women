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
    @AppStorage ("userName") var userName = ""

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
                Button(action: signin) {
                    Text("Sign in")
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40))
                        .foregroundColor(Color.white)
                        .background(Color("Morado"))
                        .cornerRadius(10)
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
    
    func signin() {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            } else {
                userID = user?.user.uid ?? ""
                Firestore.firestore().collection("users").document(userID).getDocument { snapshot, e in
                    if let snapshot = snapshot, snapshot.exists {
                        let data = snapshot.data() ?? ["name": "Nadie"]
                        userName = data["name"] as? String ?? ""
                        print("Dm:> \(userName)")
                    } else {
                        print("Em:> \(String(describing: e))")
                    }
                }
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
