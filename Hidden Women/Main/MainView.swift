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
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "square.fill.text.grid.1x2")
                                        .font(.system(size: 64))
                                    //                                Image("QuizPicture")
                                    //                                    .resizable()
                                    //                                    .scaledToFit()
                                    //                                    .rotationEffect(Angle(degrees: 15))
                                    //                                    .frame(width: 125, height: 125)
                                    //                                    .shadow(radius: 10)
                                    Text("Quiz")
                                        .font(.largeTitle)
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                    }
                    NavigationLink(destination: MultipleTrueOrFalseView(currentMultipleTrueOrFalsePage: .start)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Hueso"))
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "square.fill.and.line.vertical.and.square")
                                        .font(.system(size: 64))
                                    //                                Image("TrueOrFalsePicture")
                                    //                                    .resizable()
                                    //                                    .scaledToFit()
                                    //                                    .rotationEffect(Angle(degrees: 15))
                                    //                                    .frame(width: 125, height: 125)
                                    //                                    .shadow(radius: 10)
                                    Text("True or False")
                                        .font(.largeTitle)
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                    }
                    NavigationLink(destination: MultipleChronolineView(currentMultipleChronolinePage: .start)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Hueso"))
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "arrow.up.arrow.down.square.fill")
                                        .font(.system(size: 64))
                                    //                                Image("ChronoPicture")
                                    //                                    .resizable()
                                    //                                    .scaledToFit()
                                    //                                    .rotationEffect(Angle(degrees: 15))
                                    //                                    .frame(width: 125, height: 125)
                                    //                                    .shadow(radius: 10)
                                    Text("Chronoline")
                                        .font(.largeTitle)
                                    Spacer()
                                }
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
