//
//  MultipleTrueOrFalseView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 12/3/21.
//

import SwiftUI

enum MultipleTrueOrFalsePages {
    case start
    case question
}
let trueOrFalseTotalTime = 3

struct MultipleTrueOrFalseView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage ("userID") var userID: String = ""
    @State var currentMultipleTrueOrFalsePage: MultipleTrueOrFalsePages
    @State var correctAnswers: Int = 0
    @State var shownTrueOrFalse: Int = 0
    @State var progress: Float = 0.0
    @State var trueOrFalses: [TrueOrFalse] = []
    @State var scoreUpdated: Bool = false
    @State var showTimer: Bool = true
    @State var timeLeft: Int = trueOrFalseTotalTime
    
    var body: some View {
        Group {
            switch currentMultipleTrueOrFalsePage {
            case .start:
                VStack {
                    Spacer()
                    Text("True or false")
                        .font(.largeTitle)
                    Text("_TrueOrFalse Help_")
                    Button(action: {
                        trueOrFalses = fullTrueOrFalseGenerator(women: women, numberOfQuestions: 5)
                        currentMultipleTrueOrFalsePage = .question
                        scoreUpdated = false
                    }) {
                        Text("Start")
                    }
                    Spacer()
                }
            case .question:
                if shownTrueOrFalse == trueOrFalses.count {
                    VStack {
                        Text(
                            String.localizedStringWithFormat(
                                NSLocalizedString("Points: %@", comment: ""), String(correctAnswers))
                        )
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                    }
                    .onAppear{
                        if !scoreUpdated {
                            let gameResult = GameResult(date: Int(Date().timeIntervalSince1970), gameType: "TrueOrFalse", points: correctAnswers)
                            if userID != "" {
                                profile.gameResults.append(gameResult)
                                updateGameResults(profile: profile, userID: userID)
                            }
                            scoreUpdated = true
                        }
                    }
                }
                if shownTrueOrFalse != trueOrFalses.count {
                    VStack {
                        ProgressView(value: progress)
                            .animation(.default)
                        TrueOrFalseView(
                            trueOrFalse: trueOrFalses[shownTrueOrFalse],
                            shownTrueOrFalse: $shownTrueOrFalse,
                            correctAnswers: $correctAnswers,
                            progress: $progress,
                            numberOfTrueOrFalses: trueOrFalses.count,
                            timeLeft: $timeLeft,
                            showTimer: $showTimer
                        )
                    }
                }
            }
        }
        .navigationBarItems(trailing:
                                Group {
                                    if showTimer && currentMultipleTrueOrFalsePage == .question {
                                        ZStack {
                                            Circle()
                                                .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                            Circle()
                                                .trim(from: 0, to: CGFloat(timeLeft) / CGFloat(trueOrFalseTotalTime))
                                                .stroke(Color("Morado"), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                                .rotationEffect(.degrees(-90))
                                                .animation(.easeInOut)
                                        }
                                        .frame(width:30, height: 30)
                                    }
                                }
        )
        .onChange(of: shownTrueOrFalse) { newShownTrueOrFalse in
            if newShownTrueOrFalse < trueOrFalses.count {
                showTimer = true
            }
        }
        
    }
}


//struct MultipleTrueOrFalseView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultipleTrueOrFalseView()
//    }
//}
