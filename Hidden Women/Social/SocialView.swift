//
//  SocialView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 27/3/21.
//

import SwiftUI

struct SocialView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage ("userID") var userID: String = ""
    @Binding var currentPage: Page
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: MyFriendsView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 32, weight: .bold))
                            Text("My friends")
                                .font(.largeTitle)
                        }
                    }
                    .padding()
                }
                NavigationLink(destination: RankingView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            VStack {
                                HStack {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 32, weight: .bold))
                                    Text("Ranking")
                                        .font(.largeTitle)
                                }
                                Text("Check how your friends are doing with the games")
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .padding()
                }
                NavigationLink(destination: MakeNewFriendsView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            Image(systemName: "person.fill.badge.plus")
                                .font(.system(size: 32, weight: .bold))
                            Text("Send a friend request")
                                .font(.largeTitle)
                        }
                    }
                    .padding()
                }
                
                NavigationLink(destination: ProcessFriendRequests()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            VStack {
                                HStack {
                                    Image(systemName: profile.friendRequests.count > 0 ? "envelope.badge" : "envelope")
                                        .font(.system(size: 32, weight: .bold))
                                    Text("Friend requests")
                                        .font(.largeTitle)
                                }
                                if profile.friendRequests.count == 0 { //TODO: Actualizar la lista de peticiones al entrar en la pantalla.
                                    Text("You have no friend requests.")
                                } else {
                                    Text("You have \(profile.friendRequests.count) friend request\(profile.friendRequests.count == 1 ? "" : "s")")
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                
                NavigationLink(destination: Text("Find people like me")) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.system(size: 32, weight: .bold))
                            Text("Find people like me")
                                .font(.largeTitle)
                        }
                    }
                    .padding()
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadProfile(userID: userID, profile: profile)
            }
        }
        
    }
}


struct SocialView_Previews: PreviewProvider {
    @State static var currentPage: Page = .main
    
    static var previews: some View {
        SocialView(currentPage: $currentPage)
            .environmentObject(Profile())
    }
}
