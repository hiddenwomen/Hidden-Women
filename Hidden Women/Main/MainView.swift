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
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            WomenView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Hidden Women")
                }
                .tag(0)

            MultipleQuizView()
                .tabItem{
                    Image(systemName: "person.fill.questionmark")
                    Text("Games")
                }
                .tag(1)

            VStack {
                Text(userID)
                Button(action: {
                    userID = ""
                    currentPage = .login
                    
                }) {
                    Text("Sign out")
                }
            }
            .tabItem{
                Image(systemName: "person.circle")
                Text("Profile")
            }
            .tag(2)
            
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
