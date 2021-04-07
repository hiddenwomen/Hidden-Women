//
//  MultipleChronolineView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 16/3/21.
//

import SwiftUI

enum MultipleChronolinePages {
    case start
    case question
}

let chronolineTotalTime = 3

struct ChronolineMistake: Identifiable {
    let chronolineNumber: Int
    let sortedWomenList: [Woman]
    let mistakenWomenList: [Woman]
    let id = UUID()
}

struct MultipleChronolineView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage ("userID") var userID: String = ""
    @State var currentMultipleChronolinePage: MultipleChronolinePages
    @State var correctAnswers: Int = 0
    @State var shownChronoline: Int = 0
    @State var progress: Float = 0.0
    @State var chronoline = chronolineGenerator(women: [], numberOfWomen: 0, x: CGFloat(0.0), height: CGFloat(0.0))
    let numberOfChronolines = 3
    @State var scoreUpdated: Bool = false
    @State var showTimer: Bool = true
    @State var timeLeft: Int = trueOrFalseTotalTime
    @State var mistakes: [ChronolineMistake] = []
    
    var body: some View {
        Group {
            switch currentMultipleChronolinePage {
            case .start:
                GeometryReader { geo in
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("Chronoline")
                                .font(.largeTitle)
                                .padding()
                            Text("_Chronoline Help_")
                            Button(action: {
                                chronoline = chronolineGenerator(women: women, numberOfWomen: 5, x: geo.size.width/2.0, height: geo.size.height)
                                currentMultipleChronolinePage = .question
                                scoreUpdated = false
                            }) {
                                Text("Start")
                                    .bold()
                            }
                            .importantButtonStyle()
                            Spacer()
                        }
                        Spacer()
                    }
                    
                }
            case .question:
                if shownChronoline < numberOfChronolines {
                    VStack {
                        ProgressView(value: progress)
                            .animation(.default)
                        ChronolineView(
                            shownChronoline: $shownChronoline,
                            progress: $progress,
                            correctAnswers: $correctAnswers,
                            numberOfChronolines: numberOfChronolines,
                            chronoline: chronoline,
                            timeLeft: $timeLeft,
                            showTimer: $showTimer,
                            mistakes: $mistakes
                        )
                    }
                } else {
                    VStack {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("Turquesa"))
                                .frame(width: 125, height: 125)
                            VStack{
                                Text("\(correctAnswers)")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.largeTitle)
                                if correctAnswers == 1{
                                    Text("point")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                } else {
                                    Text("points")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                }
                            }
                        }
                        .padding()
                        Text("Things you should learn:")
                            .font(.title)
                        ScrollView {
                            VStack (alignment: .leading){
                                ForEach (mistakes) { mistake in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Image(systemName: "play")
                                            Text("Chronoline").bold() + Text(" \(mistake.chronolineNumber)").bold()
                                        }
                                        Text("Left: your answer. Right: correct answer.")
                                        ForEach(0..<mistake.mistakenWomenList.count) { i in
                                            HStack {
                                                Image(mistake.mistakenWomenList[i].pictures[0])
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 50)
                                                    .padding(.trailing, 10)
                                                Image(mistake.sortedWomenList[i].pictures[0])
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 50)
                                                VStack(alignment: .leading) {
                                                    Text(mistake.sortedWomenList[i].name.localized)
                                                        .fontWeight(.bold)
                                                    Text(mistake.sortedWomenList[i].birthYear.localized)
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            .onAppear{
                                if !scoreUpdated {
                                    let gameResult = GameResult(date: Int(Date().timeIntervalSince1970), gameType: "Chrono", points: correctAnswers)
                                    if userID != "" {
                                        profile.updateGameResults(withNewGameResult: gameResult) { error in
                                            //TODO: Error
                                        }
                                    }
                                    scoreUpdated = true
                                }
                            }
                        }
                    }
                }
            }
        }.navigationBarItems(trailing:
                                Group {
                                    if showTimer && currentMultipleChronolinePage == .question {
                                        ZStack {
                                            Circle()
                                                .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                            Circle()
                                                .trim(from: 0, to: CGFloat(timeLeft) / CGFloat(chronolineTotalTime))
                                                .stroke(Color("Morado"), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                                .rotationEffect(.degrees(-90))
                                                .animation(.easeInOut)
                                        }
                                        .frame(width:30, height: 30)
                                    }
                                }
        )
        .onChange(of: shownChronoline) { newShownChronoline in
            if newShownChronoline < numberOfChronolines {
                showTimer = true
            }
        }
    }
}


struct MultipleChronolineView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleChronolineView(currentMultipleChronolinePage: .start)
    }
}

