//
//  GamesView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 1/4/21.
//

import SwiftUI


struct GamesView: View {
    var body: some View {
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
                                Text("Quiz")
                                    .font(.largeTitle)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                NavigationLink(destination: MultipleTrueOrFalseView(currentMultipleTrueOrFalsePage: .start)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "square.fill.and.line.vertical.and.square")
                                    .font(.system(size: 64))
                                Text("True or False")
                                    .font(.largeTitle)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal)
                NavigationLink(destination: MultipleChronolineView(currentMultipleChronolinePage: .start)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "arrow.up.arrow.down.square.fill")
                                    .font(.system(size: 64))
                                Text("Chronoline")
                                    .font(.largeTitle)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal)
                NavigationLink(
                    destination: MultiplePairThemUpView(currentMultiplePairThemUpPage: .start)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Hueso"))
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "circlebadge.2.fill")
                                    .font(.system(size: 64))
                                Text("Pair them up")
                                    .font(.largeTitle)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.bottom)
                .padding(.horizontal)
            }
            .listStyle(PlainListStyle())
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .padding(0)
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
    }
}
