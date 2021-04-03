//
//  ProfileView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 18/3/21.
//

import SwiftUI

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
        if userID != "" {
            VStack {
                switch profilePage {
                case .profile:
                    VStack {
                        Image(uiImage: profile.picture ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 300, height: 300)
                        Text(profile.name)
                            .fontWeight(.bold)
                        Text(profile.email)
                        Button(action: {
                            profilePage = .editProfile
                        }) {
                            Text("Edit profile")
                                .fontWeight(.bold)
                                .importantButtonStyle()
                        }
                        .padding()
                        Spacer()
                        ZStack {
                            Circle()
                                .foregroundColor(Color("Turquesa"))
                                .frame(width: 125, height: 125)
                            VStack{
                                Text("\(profile.points)")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.largeTitle)
                                if profile.points != 1 {
                                    Text("points")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                } else {
                                    Text("point")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                }
                            }
                        }
                        .padding()
                        Spacer()
                        
                        Button(action: {
                            userID = ""
                            currentPage = .login
                        }) {
                            Text("Sign out")
                        }
                        .padding()
                        
                    }
                case .editProfile:
                    EditProfileView(profilePage: $profilePage)
                }
            }
        } else {
            VStack {
                Text("You are a guest.")
                Button(action: {
                    currentPage = .signup
                }) {
                    Text("Sign up now!")
                        .fontWeight(.bold)
                        .importantButtonStyle()
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
