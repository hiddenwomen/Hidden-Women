//
//  ProfileView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 18/3/21.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage ("userID") var userID: String = ""
    @Binding var currentPage: Page
    
    var body: some View {
        VStack {
            Text(profile.name)
            Text(profile.email)
            Text(userID)
            Button(action: {
                userID = ""
                currentPage = .login
            }) {
                Text("Sign out")
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var currentPage: Page = .main
    static var previews: some View {
        ProfileView(currentPage: $currentPage)
    }
}
