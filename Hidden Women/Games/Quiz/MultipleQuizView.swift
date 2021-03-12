//
//  MultipleQuizView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 11/3/21.
//

import SwiftUI

struct MultipleQuizView: View {
    @State var correctAnswers: Int = 0
    @State var shownQuiz: Int = 0
    
    let quizzes: [Quiz] =  fullQuizGenerator(women: women, count: 2)
    
    var body: some View {
        Group {
            if shownQuiz == quizzes.count {
                VStack {
                    Text("Points: \(correctAnswers)")
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
            if shownQuiz != quizzes.count {
                VStack {
                    Text("\(shownQuiz+1)/\(quizzes.count)")
                    QuizView(quiz: quizzes[shownQuiz], shownQuiz: $shownQuiz, correctAnswers: $correctAnswers)
                }
            }
        }
    }
}

struct MultipleQuizView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleQuizView()
    }
}
