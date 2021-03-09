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
    
    var body: some View {
        TabView{
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
                VStack{
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    @State static var page: Page = .main
    static var previews: some View {
        MainView(currentPage: $page)
    }
}
