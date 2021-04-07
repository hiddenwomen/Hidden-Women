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

struct QuizMistake: Identifiable {
    let question: String
    let correctAnswer: String
    let incorrectAnswer: String?
    let id = UUID()
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
    @State var mistakes: [QuizMistake] = []
    
    @State var quizzes: [Quiz] =  []
    
    var body: some View {
        Group {
            switch currentMultipleQuizPage {
            case .start :
                VStack {
                    Spacer()
                    Text("Quiz")
                        .font(.largeTitle)
                        .padding()
                    Text("_Quiz Help_")
                    Button(action: {
                        quizzes = fullQuizGenerator(women: women, numberOfQuestions: 5)
                        currentMultipleQuizPage = .question
                        scoreUpdated = false
                    }) {
                        Text("Start")
                            .bold()
                    }
                    .importantButtonStyle()
                    .padding()
                    Spacer()
                }
            case .question :
                if shownQuiz == quizzes.count {
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
                                    HStack (alignment: .firstTextBaseline){
                                        Image(systemName: "play")
                                        VStack (alignment: .leading){
                                            Text("\(mistake.question)")
                                                .fontWeight(.bold)
                                            HStack(alignment: .firstTextBaseline) {
                                                Image(systemName: "circlebadge.fill")
                                                    .foregroundColor(Color("Turquesa"))
                                                if mistake.incorrectAnswer == "You ran out of time" {
                                                    Text("You ran out of time")
                                                } else {
                                                    Text(
                                                        String.localizedStringWithFormat(NSLocalizedString("You chose: %@", comment: ""), mistake.incorrectAnswer!)
                                                    )
                                                }
                                            }
                                            HStack(alignment: .firstTextBaseline) {
                                                Image(systemName: "circlebadge.fill")
                                                    .foregroundColor(Color("Morado"))
                                                Text(
                                                    String.localizedStringWithFormat(NSLocalizedString("The correct answer was: %@", comment: ""), mistake.correctAnswer)
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .onAppear{
                        if !scoreUpdated {
                            let gameResult = GameResult(date: Int(Date().timeIntervalSince1970), gameType: "Quiz", points: correctAnswers)
                            print("puntos : \(correctAnswers)")
                            if userID != "" {
                                profile.updateGameResults(withNewGameResult: gameResult) { error in
                                    //TODO: Error
                                }
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
                                showTimer: $showTimer,
                                mistakes: $mistakes
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
