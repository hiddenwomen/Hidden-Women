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
                VStack {
                    NavigationLink(destination: MultipleQuizView(currentMultipleQuizPage: .start)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Hueso"))
                            HStack {
                                Image("QuizPicture")
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(Angle(degrees: 15))
                                    .frame(width: 125, height: 125)
                                    .shadow(radius: 10)
                                Text("Quiz")
                                    .font(.largeTitle)
                            }
                        }
                        .padding()
                    }
                    NavigationLink(destination: MultipleTrueOrFalseView(currentMultipleTrueOrFalsePage: .start)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Hueso"))
                            HStack {
                                Image("TrueOrFalsePicture")
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(Angle(degrees: 15))
                                    .frame(width: 125, height: 125)
                                    .shadow(radius: 10)
                                Text("True or False")
                                    .font(.largeTitle)
                            }
                        }
                        .padding()
                    }
                    NavigationLink(destination: MultipleChronolineView(currentMultipleChronolinePage: .start)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Hueso"))
                            HStack {
                                Image("ChronoPicture")
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(Angle(degrees: 15))
                                    .frame(width: 125, height: 125)
                                    .shadow(radius: 10)
                                Text("Chronoline")
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
            .tabItem{
                Image(systemName: "gamecontroller.fill")
                Text("Games")
            }
            .tag(1)
            
            SocialView(currentPage: $currentPage)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Friends")
                }
                .tag(2)
            
            
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
