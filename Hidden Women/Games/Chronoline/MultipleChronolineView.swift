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
    @State var chronoline = chronolineGenerator(women: [], numberOfWomen: 0, x: CGFloat(0.0), height: CGFloat(0.0))
    let numberOfChronolines = 3
    
    var body: some View {
        switch currentMultipleChronolinePage {
        case .start:
            GeometryReader { geo in
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("Hola")
                        Button(action: {
                            chronoline = chronolineGenerator(women: women, numberOfWomen: 5, x: geo.size.width/2.0, height: geo.size.height)
                            currentMultipleChronolinePage = .question
                        }) {
                            Text("Start")
                        }
                        Spacer()
                    }
                    Spacer()
                }
                
            }
        case .question:
            if shownChronoline == numberOfChronolines {
                VStack {
                    Text("Points: \(correctAnswers)")
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
            if shownChronoline != numberOfChronolines {
                VStack {
                    ProgressView(value: progress)
                    ChronolineView(
                        shownChronoline: $shownChronoline,
                        progress: $progress,
                        correctAnswers: $correctAnswers,
                        numberOfChronolines: numberOfChronolines,
                        chronoline: chronoline
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
