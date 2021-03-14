//
//  TrueOrFalseView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 12/3/21.
//

import SwiftUI

struct TrueOrFalseView: View {
    let trueOrFalse: TrueOrFalse
    @Binding var shownTrueOrFalse: Int
    @Binding var correctAnswers: Int
    @Binding var progress: Float
    var numberOfTrueOrFalses: Int
    
    
    var body: some View {
        VStack {
            Image(trueOrFalse.picture)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 200)
                .padding(.vertical)
            Text(trueOrFalse.question)
            
            HStack {
                Spacer()
                Button(action: {
                    if trueOrFalse.correct == false{
                        correctAnswers += 1
                    }
                    progress += 1.0 / Float(numberOfTrueOrFalses)
                    shownTrueOrFalse += 1
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("Turquesa"))
                            .frame(width: 100, height: 100)
                        Text("False")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    }
                }
                Spacer()
                Button(action: {
                    if trueOrFalse.correct == true{
                        correctAnswers += 1
                    }
                    progress += 1.0 / Float(numberOfTrueOrFalses)
                    shownTrueOrFalse += 1
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("Morado"))
                            .frame(width: 100, height: 100)
                        Text("True")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    }
                }
                Spacer()
            }
            .padding(.top, 40)
            Spacer()
        }
    }
}

//struct TrueOrFalseView_Previews: PreviewProvider {
//    static let trueOrFalse = TrueOrFalse(picture: "Curie1", question: "hola", correct: true)
//    
//    static var previews: some View {
//        TrueOrFalseView(trueOrFalse: trueOrFalse)
//    }
//}
