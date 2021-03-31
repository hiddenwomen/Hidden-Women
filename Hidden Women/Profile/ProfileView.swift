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

//enum ProfileTabs {
//    case first
//}

struct ProfileView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage ("userID") var userID: String = ""
    @Binding var currentPage: Page
    @State var profilePage: ProfilePages = .profile
    //@State var selectedUpperTab: ProfileTabs = .first
    
    var body: some View {
        if userID != "" {
            VStack {
//                HStack {
//                    Spacer()
//                    VStack {
//                        Image(systemName: selectedUpperTab == .first ? "person.fill" : "person")
//                            .foregroundColor(selectedUpperTab == .first ? Color.accentColor : Color.gray)
//                        Text("First tab")
//                    }
//                    .onTapGesture {
//                        //self.selectedTab = .FirstTab
//                    }
//                    Spacer()
//                }
                switch profilePage {
                case .profile:
                    VStack {
                        Spacer()
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
                        //List(profile.gameResults) { result in
                        //    Text("\(result.gameType): \(result.points)")
                        //}
                        Text("POINTS: \(profile.points)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Turquesa"))
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
