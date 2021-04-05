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
                    .padding()
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
        }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
    }
}
