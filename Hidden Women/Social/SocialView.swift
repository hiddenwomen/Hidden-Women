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
    let iconSize = CGFloat(56 * UIScreen.height / 896)
    let titleSize = CGFloat(34 * UIScreen.height / 896)
    let captionSize = CGFloat(18 * UIScreen.height / 896)
    
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
                                .font(.system(size: iconSize, weight: .bold))
                                .opacity(0.4)
                                .padding(.leading, 10)
                            VStack (alignment: .leading) {
                                Text("Ranking")
                                    .font(.system(size: titleSize))
                                Text("Check how your friends have been doing with the games in the last 7 days")
                                    .font(.system(size: captionSize))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                NavigationLink(destination: MyFriendsView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            VStack (alignment: .leading) {
                                HStack {
                                    Image(systemName: "person.2.fill")
                                        .font(.system(size: iconSize, weight: .bold))
                                        .opacity(0.4)
                                        .padding(.leading, 10)
                                    VStack(alignment: .leading) {
                                        Text("My friends")
                                            .font(.system(size: titleSize))
                                        Text("Check on your friends")
                                            .font(.system(size: captionSize))
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                            Spacer()
                            
                        }
                    }
                }
                .padding(.horizontal)
                
                NavigationLink(destination: MakeNewFriendsView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            VStack (alignment: .leading) {
                                HStack {
                                    Image(systemName: "person.fill.badge.plus")
                                        .font(.system(size: iconSize, weight: .bold))
                                        .opacity(0.4)
                                        .padding(.leading, 10)
                                    VStack(alignment: .leading) {
                                        Text("Send a friend request")
                                            .font(.system(size: titleSize))
                                        Text("Ask somebody to be your friend")
                                            .font(.system(size: captionSize))
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                
                NavigationLink(destination: FindPeopleView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            VStack (alignment: .leading) {
                                HStack {
                                    Image(systemName: "plus.magnifyingglass")
                                        .font(.system(size: iconSize, weight: .bold))
                                        .opacity(0.4)
                                        .padding(.leading, 10)
                                    VStack (alignment: .leading) {
                                        Text("Find people like me")
                                            .font(.system(size: titleSize))
                                        if profile.favourites.count == 0 {
                                            Text("You have to select some Hidden Women as favourites to find people like you.")
                                        } else {
                                            Text("Find people with similar favourite Hidden Women")
                                                .font(.system(size: captionSize))
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.leading)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                .disabled(profile.favourites.count == 0)
                
                NavigationLink(destination: FriendRequestsView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        HStack {
                            VStack (alignment: .leading) {
                                HStack {
                                    Image(systemName: profile.friendRequests.count > 0 ? "envelope.badge" : "envelope")
                                        .font(.system(size: iconSize, weight: .bold))
                                        .opacity(0.4)
                                        .padding(.leading, 10)
                                    VStack (alignment: .leading) {
                                        Text("Friend requests")
                                            .font(.system(size: titleSize))
                                        if profile.friendRequests.count == 0 { //TODO: Actualizar la lista de peticiones al entrar en la pantalla.
                                            Text("You have no friend requests.")
                                                .font(.system(size: captionSize))
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.leading)
                                        } else if profile.friendRequests.count == 1 {
                                            Text("You have 1 friend request")
                                                .font(.system(size: captionSize))
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.leading)
                                        } else {
                                            Text(
                                                String.localizedStringWithFormat(NSLocalizedString("You have %@ friend requests", comment: ""), String(profile.friendRequests.count))
                                            )
                                            .font(.system(size: captionSize))
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
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
