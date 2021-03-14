//
//  MultipleTrueOrFalseView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 12/3/21.
//

import SwiftUI

enum MultipleTrueOrFalsePages {
    case start
    case question
}

struct MultipleTrueOrFalseView: View {
    @State var currentMultipleTrueOrFalsePage: MultipleTrueOrFalsePages
    @State var correctAnswers: Int = 0
    @State var shownTrueOrFalse: Int = 0
    @State var progress: Float = 0.0
    @State var trueOrFalses: [TrueOrFalse] = []
    
    var body: some View {
        switch currentMultipleTrueOrFalsePage {
        case .start:
            VStack {
                Text("Hola")
                Button(action: {
                    trueOrFalses = fullTrueOrFalseGenerator(women: women, numberOfQuestions: 5)
                    currentMultipleTrueOrFalsePage = .question
                }) {
                    Text("Start")
                }
            }
        case .question:
            if shownTrueOrFalse == trueOrFalses.count {
                VStack {
                    Text("Points: \(correctAnswers)")
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
            if shownTrueOrFalse != trueOrFalses.count {
                VStack {
                    ProgressView(value: progress)
                    TrueOrFalseView(
                        trueOrFalse: trueOrFalses[shownTrueOrFalse],
                        shownTrueOrFalse: $shownTrueOrFalse,
                        correctAnswers: $correctAnswers,
                        progress: $progress, numberOfTrueOrFalses: trueOrFalses.count
                     )
                }
            }
        }
    }
    }


//struct MultipleTrueOrFalseView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultipleTrueOrFalseView()
//    }
//}
