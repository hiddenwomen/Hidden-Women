//
//  ProfileView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 18/3/21.
//

import SwiftUI
import Firebase

enum ProfilePages {
    case profile
    case editProfile
}

struct ProfileView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage ("userID") var userID: String = ""
    @Binding var currentPage: Page
    @State var profilePage: ProfilePages = .profile
    
    var body: some View {
        Group {
            switch profilePage {
            case .profile:
            VStack {
                Image(uiImage: profile.picture ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Text(profile.name)
                Text(profile.email)
                Text(userID)
                Button(action: {
                    profilePage = .editProfile
                }) {
                    Text("Edit profile")
                }
                Button(action: {
                    userID = ""
                    currentPage = .login
                }) {
                    Text("Sign out")
                }
                
            }

            case .editProfile:
                EditProfileView(profilePage: $profilePage)
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
