//
//  MultipleQuizView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 11/3/21.
//

import SwiftUI

struct MultipleQuizView: View {
    @State var correctAnswers: Int = 0
    
    let quizzes: [Quiz] =  [
        Quiz(
            picture: "Curie1",
            question: "What award was given to Madame Curie?",
            answers: [
                "Chemistry Nobel Prize",
                "Gran Prix",
                "1, 2, 3",
                "Bonoloto"
            ],
            correctAnswer: 0),
        Quiz(
            picture: "Lovelace1",
            question: "When was Ada Lovelace born?",
            answers: [
                "1476",
                "1815",
                "2020",
                "1820"
            ],
            correctAnswer: 1)]
    @State var shownQuiz: Int = 0
    
    var body: some View {
        if shownQuiz == quizzes.count{
            Text("Points: \(correctAnswers)")
        } else{
            
            VStack {
                Text("\(shownQuiz+1)/\(quizzes.count)")
                QuizView(quiz: quizzes[shownQuiz], shownQuiz: $shownQuiz, correctAnswers: $correctAnswers)
            }
        }
    }
}

struct MultipleQuizView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleQuizView()
    }
}
