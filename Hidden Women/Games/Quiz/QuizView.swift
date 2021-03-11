//
//  QuizView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 11/3/21.
//

import SwiftUI
 
struct QuizView: View {
    let quiz: Quiz
    @State var chosenAnswer: Int? = nil
    @Binding var shownQuiz: Int
    @Binding var correctAnswers: Int
    
    var body: some View {
        VStack{
            Image(quiz.picture)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 200)
                .padding(.vertical)
            Text(quiz.question)
            VStack (alignment: .leading){
                ForEach(0..<quiz.answers.count){ i in
                    HStack {
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
                        correctAnswers = correctAnswers + 1
                    }
                    shownQuiz = shownQuiz + 1
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
            Spacer()
        }
       
    }

}
    
    struct QuizView_Previews: PreviewProvider {
        @State static var shownQuiz: Int = 0
        @State static var correctAnswers: Int = 0
        
        static var previews: some View {
            QuizView(quiz: Quiz(
                        picture: "Curie1",
                        question: "What award was given to Madame Curie?",
                        answers: [
                            "Chemistry Nobel Prize",
                            "Gran Prix",
                            "1, 2, 3",
                            "Bonoloto"
                        ],
                        correctAnswer: 0), shownQuiz: $shownQuiz, correctAnswers: $correctAnswers)
        }
    }
