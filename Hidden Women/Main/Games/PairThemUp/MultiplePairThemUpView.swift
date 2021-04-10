//
//  MultiplePairThemUpView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 5/4/21.
//

import SwiftUI

enum MultiplePairThemUpPages {
    case start
    case question
}

struct PairThemUpConfig {
    let games: Int
    let numberOfWomen: Int
    let availableTime: Int
}

let pairThemUpConfig = PairThemUpConfig(
    games: 3,
    numberOfWomen: 5,
    availableTime: 20
)

struct MultiplePairThemUpView: View {
    @EnvironmentObject var profile: Profile
    @State var currentMultiplePairThemUpPage: MultiplePairThemUpPages
    @State var correctAnswers: Int = 0
    @State var shownPairThemUp: Int = 0
    @State var progress: CGFloat = 0.0
    @State var pairThemUp = pairThemUpGenerator(
        numberOfWomen: pairThemUpConfig.numberOfWomen,
        women: women,
        xName: UIScreen.width - 70,
        xPicture: 70,
        firstY: 70,
        lastY: UIScreen.height - 200
    )
    @State var scoreUpdated: Bool = false
    @State var showTimer: Bool = true
    @State var timeLeft: Int = pairThemUpConfig.availableTime
    @State var mistakes: [[PairThemUpMistake]] = []
    let numberOfPairThemUp = pairThemUpConfig.games

    var body: some View {
        Group {
            switch currentMultiplePairThemUpPage {
            
            case .start:
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("Pair them up")
                            .font(.largeTitle)
                            .padding()
                        Text("_PairThemUp Help_")
                            .padding()
                        Button(action: {
                            currentMultiplePairThemUpPage = .question
                            scoreUpdated = false
                        }) {
                            Text("Start")
                                .bold()
                                .importantButtonStyle()
                        }
                        Spacer()
                    }
                    Spacer()
                }

            case .question:
                if shownPairThemUp < pairThemUpConfig.games {
                    VStack {
                        ProgressView(value: progress)
                            .animation(.default)
                        PairThemUpView(
                            pairThemUpGame: $pairThemUp,
                            activateSubmit: false,
                            shownPairThemUp: $shownPairThemUp,
                            progress: $progress,
                            timeLeft: $timeLeft,
                            showTimer: $showTimer,
                            mistakes: $mistakes,
                            correctAnswers: $correctAnswers,
                            numberOfPairThemUp: pairThemUpConfig.games
                        )
                    }
                } else {
                    VStack {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("Turquesa"))
                                .frame(width: 125, height: 125)
                            VStack{
                                Text("\(max(0, correctAnswers))")
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
                        if mistakes.allSatisfy({$0.count == 0}) {
                            Text("Perfect score!")
                                .font(.title)
                        } else {
                            Text("Things you should learn:")
                                .font(.title)
                        }
                        ScrollView {
                            VStack (alignment: .leading){
                                ForEach(0..<mistakes.count) { m in
                                    Group {
                                        if mistakes[m].count > 0 {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Image(systemName: "play")
                                                    Text("Pair them up").bold() + Text(" \(m+1)").bold()
                                                }
                                                ForEach(0..<mistakes[m].count) { i in
                                                    HStack {
                                                        Image(mistakes[m][i].picture)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 50)
                                                            .clipShape(Circle())
                                                            .padding(.trailing, 10)
                                                        VStack(alignment: .leading) {
                                                            Text(
                                                                String.localizedStringWithFormat(NSLocalizedString("Your answer: %@", comment: ""), NSLocalizedString(mistakes[m][i].incorrectAnswer, comment: ""))
                                                            )
                                                            Text(
                                                                String.localizedStringWithFormat(NSLocalizedString("Correct answer: %@", comment: ""), mistakes[m][i].correctAnswer)
                                                            )
                                                        }
                                                        Spacer()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            .onAppear{
                                if !scoreUpdated {
                                    if !profile.isGuest {
                                        let gameResult = GameResult(
                                            date: Int(Date().timeIntervalSince1970),
                                            gameType: "PairThemUp",
                                            points: max(0, correctAnswers)
                                        )
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
                                    if showTimer && currentMultiplePairThemUpPage == .question {
                                        ZStack {
                                            Circle()
                                                .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                            Circle()
                                                .trim(from: 0, to: CGFloat(timeLeft) / CGFloat(pairThemUpConfig.availableTime))
                                                .stroke(Color("Morado"), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                                .rotationEffect(.degrees(-90))
                                                .animation(.easeInOut)
                                        }
                                        .frame(width:30, height: 30)
                                    }
                                }
        )
        .onChange(of: shownPairThemUp) { newShownPairThemUp in
            if newShownPairThemUp < pairThemUpConfig.games {
                showTimer = true
            }
        }
    }
}

//struct MultiplePairThemUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultiplePairThemUpView()
//    }
//}
