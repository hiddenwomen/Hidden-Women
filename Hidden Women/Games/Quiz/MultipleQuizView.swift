//
//  MultipleQuizView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 11/3/21.
//

import SwiftUI

enum MultipleQuizPages {
    case start
    case question
}

struct MultipleQuizView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage ("userID") var userID: String = ""
    @State var currentMultipleQuizPage: MultipleQuizPages
    @State var correctAnswers: Int = 0
    @State var shownQuiz: Int = 0
    @State var progress: Float = 0.0
    @State var scoreUpdated: Bool = false
    @State var showTimer: Bool = true
    @State var timeLeft: Int = trueOrFalseTotalTime
    
    @State var quizzes: [Quiz] =  []
    
    var body: some View {
        Group {
            switch currentMultipleQuizPage {
            case .start :
                VStack {
                    Spacer()
                    Text("Quiz")
                        .font(.largeTitle)
                    Text("_Quiz Help_")
                    Button(action: {
                        quizzes = fullQuizGenerator(women: women, numberOfQuestions: 5)
                        currentMultipleQuizPage = .question
                        scoreUpdated = false
                    }) {
                        Text("Start")
                    }
                    Spacer()
                }
            case .question :
                if shownQuiz == quizzes.count {
                    VStack {
                        Text(
                            String.localizedStringWithFormat(NSLocalizedString("Points: %@", comment: ""), String(correctAnswers))
                        )
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                    }
                    .onAppear{
                        if !scoreUpdated {
                            let gameResult = GameResult(date: Int(Date().timeIntervalSince1970), gameType: "Quiz", points: correctAnswers)
                            print("puntos : \(correctAnswers)")
                            if userID != "" {
                                profile.gameResults.append(gameResult)
                                updateGameResults(profile: profile, userID: userID)
                            }
                            scoreUpdated = true
                        }
                    }
                } else {
                    VStack {
                        ProgressView(value: progress)
                            .animation(.default)
                        ScrollView {
                            QuizView(
                                quiz: quizzes[shownQuiz],
                                shownQuiz: $shownQuiz,
                                correctAnswers: $correctAnswers,
                                progress: $progress,
                                numberOfQuizzes: quizzes.count,
                                timeLeft: $timeLeft,
                                showTimer: $showTimer
                            )
                        }
                    }
                }
            }
        }
        .navigationBarItems(trailing:
                                Group {
                                    if showTimer && currentMultipleQuizPage == .question {
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
        .onChange(of: shownQuiz) { newShownQuiz in
            if newShownQuiz < quizzes.count {
                showTimer = true
            }
        }
    }
}

struct MultipleQuizView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleQuizView(currentMultipleQuizPage: .start)
    }
}
