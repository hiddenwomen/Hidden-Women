//
//  ContentView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/3/21.
//

import SwiftUI
import Firebase

enum Page {
    case login
    case signup
    case resetPassword
    case main
    case guest
}

struct ContentView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage("userID") var userID = ""
    @State var currentPage: Page = .login
    
    var body: some View {
        Group {
            if currentPage == .login {
                LoginView(currentPage: $currentPage)
            } else if currentPage == .signup {
                SignupView(currentPage: $currentPage)
            } else if currentPage == .resetPassword {
                ResetPasswordView(currentPage: $currentPage)
            } else if currentPage == .guest {
                GuestWarningView(currentPage: $currentPage)
            } else {
                MainView(currentPage: $currentPage)
            }
        }
        .onAppear {
            print("Entrando")
            if userID == "" {
                currentPage = .login
            } else {
                Firestore.firestore().collection("users").document(userID).getDocument { snapshot, e in
                    if let snapshot = snapshot, snapshot.exists {
                        let data = snapshot.data() ?? ["name": ""]
                        profile.name = data["name"] as? String ?? ""
                        profile.email = data["email"] as? String ?? ""
                        profile.favourites = data["favourites"] as? [String] ?? []
                    }
                    print("\(profile.name)")
                }
                let picture = Storage.storage().reference().child("\(userID)/Profile.png")
                picture.getData(maxSize: 128 * 1024 * 1024) { data, error in
                    if let error = error {
                        profile.picture = UIImage(named: "unknown")
                    } else {
                        // Data for "images/island.jpg" is returned
                        profile.picture = UIImage(data: data!) ?? UIImage(named: "unknown")
                        print("EXITO!")
                    }
                }
                currentPage = .main
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(currentPage: .signup)
    }
}
