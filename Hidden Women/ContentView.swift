//
//  ContentView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/3/21.
//

import SwiftUI

enum Page {
    case login
    case signup
    case main
}

struct ContentView: View {
    @AppStorage("userID") var userID = ""
    @State var currentPage: Page = .login
    
    var body: some View {
        Group {
            if currentPage == .login {
                LoginView(currentPage: $currentPage)
            } else if currentPage == .signup {
                SignupView(currentPage: $currentPage)
            } else {
                MainView(currentPage: $currentPage)
            }
        }
        .onAppear {
            if userID == "" {
                currentPage = .login
            } else {
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
