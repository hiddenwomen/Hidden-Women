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

let pairThemUpTotalTime = 20

struct MultiplePairThemUpView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage ("userID") var userID: String = ""
    @State var currentMultiplePairThemUpPage: MultiplePairThemUpPages
    @State var correctAnswers: Int = 0
    @State var shownPairThemUp: Int = 0
    @State var progress: CGFloat = 0.0
    @State var pairThemUp = pairThemUpGenerator(numberOfWomen: 5, women: women, xName: UIScreen.width - 70, xPicture: 70, firstY: 70, lastY: UIScreen.height - 200)
    let numberOfPairThemUp = 3
    @State var scoreUpdated: Bool = false
    @State var showTimer: Bool = true
    @State var timeLeft: Int = trueOrFalseTotalTime
    @State var mistakes: [[PairThemUpMistake]] = []
    
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
                        Text("_PairThemUp Help_")
                        Button(action: {
                            //chronoline = chronolineGenerator(women: women, numberOfWomen: 5, x: geo.size.width/2.0, height: geo.size.height)
                            currentMultiplePairThemUpPage = .question
                            scoreUpdated = false
                        }) {
                            Text("Start")
                        }
                        Spacer()
                    }
                    Spacer()
                }
                
            case .question:
                if shownPairThemUp < numberOfPairThemUp {
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
                            numberOfPairThemUp: numberOfPairThemUp
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
                                                                String.localizedStringWithFormat(NSLocalizedString("Your answer: %@", comment: ""), mistakes[m][i].incorrectAnswer)
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
                                    let gameResult = GameResult(date: Int(Date().timeIntervalSince1970), gameType: "PairThemUp", points: correctAnswers)
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
                                    if showTimer && currentMultiplePairThemUpPage == .question {
                                        ZStack {
                                            Circle()
                                                .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                            Circle()
                                                .trim(from: 0, to: CGFloat(timeLeft) / CGFloat(pairThemUpTotalTime))
                                                .stroke(Color("Morado"), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                                .rotationEffect(.degrees(-90))
                                                .animation(.easeInOut)
                                        }
                                        .frame(width:30, height: 30)
                                    }
                                }
        )
        .onChange(of: shownPairThemUp) { newShownPairThemUp in
            if newShownPairThemUp < numberOfPairThemUp {
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
