//
//  SocialView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 27/3/21.
//

import SwiftUI

struct SocialView: View {
    @EnvironmentObject var profile: Profile
    @Binding var currentPage: Page
    
    var body: some View {
            NavigationView {
                VStack {
                    NavigationLink(destination: MyFriendsView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Hueso"))
                            HStack {
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

                                Text("Ranking")
                                    .font(.largeTitle)
                            }
                        }
                        .padding()
                    }
                    NavigationLink(destination: Text("Make new friends")) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Hueso"))
                            HStack {
                                Text("Make new friends")
                                    .font(.largeTitle)
                            }
                        }
                        .padding()
                    }
                    NavigationLink(destination: Text("Find people like me")) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Hueso"))
                            HStack {
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
