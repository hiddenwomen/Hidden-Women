//
//  GamesView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/3/21.
//

import SwiftUI

struct MainView: View {
    @AppStorage ("userID") var userID = ""
    
    @Binding var currentPage: Page
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            WomenView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Hidden Women")
                }
                .tag(0)
            
            
            GamesView()
            .tabItem {
                Image(systemName: "gamecontroller.fill")
                Text("Games")
            }
            .tag(1)
            if userID != "" {
            SocialView(currentPage: $currentPage)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Friends")
                }
                .tag(2)
            }
            
            ProfileView(currentPage: $currentPage)
                .tabItem{
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(Color("Morado"))
    }
}

struct MainView_Previews: PreviewProvider {
    @State static var page: Page = .main
    
    static var previews: some View {
        MainView(currentPage: $page)
    }
}
