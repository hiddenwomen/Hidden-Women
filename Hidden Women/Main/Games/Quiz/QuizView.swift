//
//  QuizView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 11/3/21.
//

import SwiftUI

let quizTotalTime = 15

struct QuizView: View {
    let quiz: Quiz
    @State var chosenAnswer: Int? = nil
    @Binding var shownQuiz: Int
    @Binding var correctAnswers: Int
    @Binding var progress: Float
    var numberOfQuizzes: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Binding var timeLeft: Int
    @Binding var showTimer: Bool
    @Binding var mistakes: [QuizMistake]
    
    var body: some View {
            VStack {
                Image(quiz.picture)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 200)
                    .padding(.vertical)
                Text(quiz.question)
                VStack (alignment: .leading){
                    ForEach(0..<quiz.answers.count){ i in
                        HStack (alignment: .firstTextBaseline) {
                            Image(systemName: chosenAnswer == i ? "checkmark.square.fill" : "square")
                                .foregroundColor(Color("Morado"))
                            Text(quiz.answers[i])
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .onTapGesture {
                            chosenAnswer = i
                        }
                    }
                }
                .padding()
                if chosenAnswer != nil{
                    Button(action: {
                        if chosenAnswer == quiz.correctAnswer {
                            correctAnswers += 1
                        } else {
                            correctAnswers -= 1
                            mistakes.append(
                                QuizMistake(question: quiz.question,
                                            correctAnswer: quiz.answers[quiz.correctAnswer],
                                            incorrectAnswer: quiz.answers[chosenAnswer!])
                            )
                        }
                        progress += 1.0 / Float(numberOfQuizzes)
                        print("puntos : \(correctAnswers)")
                        shownQuiz = shownQuiz + 1
                        timeLeft = quizTotalTime
                        showTimer = false
                        chosenAnswer = nil
                        
                    }){
                        Text("Submit")
                            .fontWeight(.bold)
                            .padding(EdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40))
                            .foregroundColor(Color.white)
                            .background(Color("Morado"))
                            .cornerRadius(10)
                    }
                }
            }
            .onReceive(timer) { _ in
                timeLeft -= 1
                if timeLeft < 0 {
                    chosenAnswer = nil
                    timer.upstream.connect().cancel()
                    progress += 1.0 / Float(numberOfQuizzes)
                    showTimer = false
                    shownQuiz += 1
                    timeLeft = quizTotalTime
                    mistakes.append(
                        QuizMistake(question: quiz.question,
                                    correctAnswer: quiz.answers[quiz.correctAnswer],
                                    incorrectAnswer: "You ran out of time"
                    )
                    )
                }
            }
        }
    }


//struct QuizView_Previews: PreviewProvider {
//    @State static var shownQuiz: Int = 0
//    @State static var correctAnswers: Int = 0
//    @State static var progress: Float = 0.0
//
//    static var previews: some View {
//        QuizView(quiz: awardsQuizGenerator(women: women), shownQuiz: $shownQuiz, correctAnswers: $correctAnswers, progress: $progress, numberOfQuizzes: 1)
//    }
//}
