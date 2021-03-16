//
//  MultipleChronolineView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 16/3/21.
//

import SwiftUI

enum MultipleChronolinePages {
    case start
    case question
}

struct MultipleChronolineView: View {
    @State var currentMultipleChronolinePage: MultipleChronolinePages
    @State var correctAnswers: Int = 0
    @State var shownChronoline: Int = 0
    @State var progress: Float = 0.0
    @State var chronolines: [Chronoline] = []
    
    var body: some View {
        switch currentMultipleChronolinePage {
        case .start:
            VStack {
                Text("Hola")
                Button(action: {
                    chronolines = fullMultipleChronolineGenerator(
                        women: women,
                        numberOfWomen: 5,
                        height: UIScreen.height,
                        x: UIScreen.width / 2,
                        numberOfChronolines: 3
                    )
                    currentMultipleChronolinePage = .question
                }) {
                    Text("Start")
                }
            }
        case .question:
            if shownChronoline == chronolines.count {
                VStack {
                    Text("Points: \(correctAnswers)")
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
            if shownChronoline != chronolines.count {
                VStack {
                    ProgressView(value: progress)
                    ChronolineView(
                        chronoline: chronolines[shownChronoline],
                        shownChronoline: $shownChronoline,
                        progress: $progress,
                        correctAnswers: $correctAnswers,
                        numberOfChronolines: chronolines.count
                    )
                }
            }
        }
    }
}

//struct MultipleChronolineView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultipleChronolineView()
//    }
//}
