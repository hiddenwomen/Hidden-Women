//
//  GamesView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/3/21.
//

import SwiftUI
import Firebase

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
            NavigationView {
                List {
                    NavigationLink(destination: MultipleQuizView(currentMultipleQuizPage: .start)) {
                        Text("Quiz")
                    }
                    NavigationLink(destination: MultipleTrueOrFalseView(currentMultipleTrueOrFalsePage: .start)) {
                        Text("True or False")
                    }
                    NavigationLink(destination: MultipleChronolineView(currentMultipleChronolinePage: .start)) {
                        Text("Chronoline")
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
            }
                .tabItem{
                    Image(systemName: "person.fill.questionmark")
                    Text("Games")
                }
                .tag(1)
            ProfileView(currentPage: $currentPage)
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
