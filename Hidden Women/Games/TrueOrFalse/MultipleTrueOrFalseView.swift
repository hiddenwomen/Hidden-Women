//
//  MultipleTrueOrFalseView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 12/3/21.
//

import SwiftUI

struct MultipleTrueOrFalseView: View {
    @State var correctAnswers: Int = 0
    @State var shownTrueOrFalse: Int = 0
    
    let trueOrFalses: [TrueOrFalse] = [
        TrueOrFalse(picture: "Curie1", question: "blablabal", correct: true),
        TrueOrFalse(picture: "Curie2", question: "blibliblbi", correct: false)
    ]
    
    var body: some View {
        Group {
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
                    Text("\(shownTrueOrFalse+1)/\(trueOrFalses.count)")
                    TrueOrFalseView(shownTrueOrFalse: $shownTrueOrFalse,
                              correctAnswers: $correctAnswers,
                              trueOrFalse: trueOrFalses[shownTrueOrFalse]
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
