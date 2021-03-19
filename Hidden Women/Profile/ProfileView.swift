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
            if userID != "" {
                switch profilePage {
                case .profile:
                    VStack {
                        Spacer()
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
                                .fontWeight(.bold)
                                .padding(EdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40))
                                .foregroundColor(Color.white)
                                .background(Color("Morado"))
                                .cornerRadius(10)
                        }
                        Spacer()
                        
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
            } else {
                VStack {
                    Text("You are a guest.")
                    Button(action: {
                        currentPage = .signup
                    }) {
                        Text("Sign up now!")
                            .fontWeight(.bold)
                            .padding(EdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40))
                            .foregroundColor(Color.white)
                            .background(Color("Morado"))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var profile: Profile = Profile(name: "Marie Curie", email: "curie@cientifica.com")
    @State static var currentPage: Page = .main
    static var previews: some View {
        ProfileView(currentPage: $currentPage)
            .environmentObject(profile)
    }
}
