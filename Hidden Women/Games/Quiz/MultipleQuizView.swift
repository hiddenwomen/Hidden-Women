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
    
    @State var quizzes: [Quiz] =  []
    
    var body: some View {
        switch currentMultipleQuizPage {
        case .start :
            VStack {
                Text("Hola")
                Button(action: {
                    quizzes = fullQuizGenerator(women: women, numberOfQuestions: 5)
                    currentMultipleQuizPage = .question
                    scoreUpdated = false
                }) {
                    Text("Start")
                }
            }
        case .question :
            if shownQuiz == quizzes.count {
                VStack {
                    Text("Points: \(correctAnswers)")
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
                .onAppear{
                    if !scoreUpdated {
                        let gameResult = GameResult(date: Int(Date().timeIntervalSince1970), gameType: "Quiz", points: correctAnswers)
                        profile.gameResults.append(gameResult)
                        updateGameResults(profile: profile, userID: userID)
                        scoreUpdated = true
                    }
                }
            } else {
                VStack {
                    ProgressView(value: progress)
                    ScrollView {
                        QuizView(
                            quiz: quizzes[shownQuiz],
                            shownQuiz: $shownQuiz,
                            correctAnswers: $correctAnswers,
                            progress: $progress,
                            numberOfQuizzes: quizzes.count
                        )
                    }
                }
            }
        }
    }
}

struct MultipleQuizView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleQuizView(currentMultipleQuizPage: .start)
    }
}
