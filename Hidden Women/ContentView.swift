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
            if userID == "" {
                currentPage = .login
            } else {
                print("--- desde ContenView")
                // loadProfile(userID: userID, profile: profile, andFriends: true)
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
