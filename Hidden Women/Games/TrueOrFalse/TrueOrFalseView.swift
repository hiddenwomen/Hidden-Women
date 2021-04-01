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
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Binding var timeLeft: Int
    @Binding var showTimer: Bool

    var body: some View {
        VStack {
            Image(trueOrFalse.picture)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 200)
                .padding(.vertical)
            Text(trueOrFalse.question)
            Text(trueOrFalse.answer)
                .fontWeight(.bold)
            
            HStack {
                Spacer()
                Button(action: {
                    if trueOrFalse.correct == true {
                        correctAnswers += 1
                    }
                    progress += 1.0 / Float(numberOfTrueOrFalses)
                    timer.upstream.connect().cancel()
                    timeLeft = trueOrFalseTotalTime
                    showTimer = false
                    shownTrueOrFalse += 1
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("Morado"))
                            .frame(width: 160, height: 160)
                        Text("True")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    }
                }
                Spacer()
                Button(action: {
                    if trueOrFalse.correct == false{
                        correctAnswers += 1
                    }
                    progress += 1.0 / Float(numberOfTrueOrFalses)
                    timer.upstream.connect().cancel()
                    timeLeft = trueOrFalseTotalTime
                    showTimer = false
                    shownTrueOrFalse += 1
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("Turquesa"))
                            .frame(width: 160, height: 160)
                        Text("False")
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
        .onReceive(timer) { _ in
            timeLeft -= 1
            if timeLeft < 0 {
                progress += 1.0 / Float(numberOfTrueOrFalses)
                timeLeft = trueOrFalseTotalTime
                timer.upstream.connect().cancel()
                showTimer = false
                shownTrueOrFalse += 1
            }
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
