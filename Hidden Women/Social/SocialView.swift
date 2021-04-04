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
                NavigationLink(destination: RankingView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            Spacer()
                            
                        }
                        HStack {
                            Image(systemName: "rosette")
                                .font(.system(size: 52, weight: .bold))
                                .opacity(0.4)
                                .padding(.leading, 10)
                            VStack (alignment: .leading) {
                                Text("Ranking")
                                    .font(.title)
                                Text("Check how your friends have been doing with the games in the last 7 days")
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                    }
                    .padding()
                }
                NavigationLink(destination: MyFriendsView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            VStack (alignment: .leading) {
                                HStack {
                                    Image(systemName: "person.2.fill")
                                        .font(.system(size: 52, weight: .bold))
                                        .opacity(0.4)
                                        .padding(.leading, 10)
                                    Text("My friends")
                                        .font(.title)
                                }
                            }
                            Spacer()
                            
                        }
                    }
                    .padding()
                }
                
                
                NavigationLink(destination: MakeNewFriendsView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            VStack (alignment: .leading) {
                                HStack {
                                    Image(systemName: "person.fill.badge.plus")
                                        .font(.system(size: 52, weight: .bold))
                                        .opacity(0.4)
                                        .padding(.leading, 10)
                                    Text("Send a friend request")
                                        .font(.title)
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding()
                }
                
                
                NavigationLink(destination: FindPeopleView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            VStack (alignment: .leading) {
                                HStack {
                                    Image(systemName: "plus.magnifyingglass")
                                        .font(.system(size: 52, weight: .bold))
                                        .opacity(0.4)
                                        .padding(.leading, 10)
                                    VStack (alignment: .leading) {
                                        Text("Find people like me")
                                            .font(.title)
                                        if profile.favourites.count == 0 { //TODO: Actualizar la lista de peticiones al entrar en la pantalla.
                                            Text("You have to select some Hidden Women as favourites to find people like you.")
                                        } else {
                                            Text("Find people with similar favourite Hidden Women")
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding()
                }
                .disabled(profile.favourites.count == 0)
                
                NavigationLink(destination: FriendRequestsView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            VStack (alignment: .leading) {
                                HStack {
                                    Image(systemName: profile.friendRequests.count > 0 ? "envelope.badge" : "envelope")
                                        .font(.system(size: 52, weight: .bold))
                                        .opacity(0.4)
                                        .padding(.leading, 10)
                                    VStack (alignment: .leading) {
                                        Text("Friend requests")
                                            .font(.title)
                                        if profile.friendRequests.count == 0 { //TODO: Actualizar la lista de peticiones al entrar en la pantalla.
                                            Text("You have no friend requests.")
                                        } else if profile.friendRequests.count == 1 {
                                            Text("You have 1 friend request")
                                        } else {
                                            Text(
                                                String.localizedStringWithFormat(NSLocalizedString("You have %@ friend requests", comment: ""), String(profile.friendRequests.count))
                                            )
                                            
                                        }                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding()
                }
                .disabled(profile.friendRequests.count == 0)
            }
            .listStyle(PlainListStyle())
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
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
