//
//  ChronolineView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 12/3/21.
//

import SwiftUI

struct Card: Identifiable {
    var pos: CGPoint
    var woman: Woman
    let id = UUID()
}

let chronolineBase = CGFloat(0.1)
let chronolineScreenPercentage = CGFloat(0.8)

struct Chronoline {
    var cards: [Card]
    var sortedYears: [String]
    
    init(women: [Woman], x: CGFloat, height: CGFloat) {
        cards = []
        for (i, woman) in women.enumerated() {
            cards.append(
                Card(
                    pos: CGPoint(
                        x: x,
                        y: chronolineBase * height +
                            chronolineScreenPercentage * height / CGFloat(women.count) * CGFloat(i)
                    ),
                    woman: woman
                )
            )
        }
        sortedYears = women.sorted(by: {$0.birthYearAsInt < $1.birthYearAsInt }).map{$0.birthYear.localized}
    }
}

struct ChronolineMismatch {
    let woman: Woman
    let wrongYear: String
}

struct ChronolineView: View {
    @Binding var shownChronoline: Int
    @Binding var progress: Float
    @Binding var correctAnswers: Int
    let numberOfChronolines: Int
    @State var chronoline: Chronoline
    @State var dragging: Int? = nil
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Binding var timeLeft: Int
    @Binding var showTimer: Bool
    @Binding var mistakes: [ChronolineMistake]
    
    
    func sortCards(dontMoveThis: Int?, height: CGFloat) {
        let sorted = chronoline.cards.sorted(by: {$0.pos.y < $1.pos.y} )
        var y: CGFloat = chronolineBase * height
        for element in sorted {
            for i in 0..<chronoline.cards.count {
                if i != dontMoveThis && element.woman.name == chronoline.cards[i].woman.name {
                    chronoline.cards[i].pos.y = y
                    break
                }
            }
            y += chronolineScreenPercentage * height / CGFloat(chronoline.cards.count)
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack {
                    ForEach(0..<chronoline.cards.count) { i in
                        ChronoWomanView(
                            woman: chronoline.cards[i].woman,
                            width: 0.6 * geo.size.width,
                            height: geo.size.height / 5 - 40
                        )
                        .frame(
                            width: 0.6 * geo.size.width,
                            height: geo.size.height / 5 - 40
                        )
                        .shadow(radius: dragging == i ? 10 : 0)
                        .zIndex(dragging == i ? 1000 : 0)
                        .position(chronoline.cards[i].pos)
                        .gesture(
                            DragGesture()
                                .onChanged { drag in
                                    dragging = i
                                    withAnimation(.spring()) {
                                        chronoline.cards[i].pos = drag.location
                                        sortCards(dontMoveThis: i, height: geo.size.height)
                                    }
                                }
                                .onEnded { drag in
                                    dragging = nil
                                    withAnimation(.spring()) {
                                        chronoline.cards[i].pos = CGPoint(
                                            x: geo.size.width / 2,
                                            y: drag.location.y
                                        )
                                        sortCards(dontMoveThis: nil, height: geo.size.height)
                                    }
                                }
                        )
                    }
                    ForEach(0..<chronoline.sortedYears.count) { i in
                        Text(chronoline.sortedYears[i])
                            .position(
                                x: 0.1 * geo.size.width,
                                y: chronolineBase * geo.size.height +
                                    chronolineScreenPercentage * geo.size.height / CGFloat(chronoline.cards.count) * CGFloat(i))
                        Text(chronoline.sortedYears[i])
                            .position(x: 0.9 * geo.size.width,
                                      y: chronolineBase * geo.size.height +
                                        chronolineScreenPercentage * geo.size.height / CGFloat(chronoline.cards.count) * CGFloat(i))
                    }
                }
                Spacer()
                
                Button(action: {
                    progress += 1.0 / Float(numberOfChronolines)
                    shownChronoline += 1
                    scoreIfSorted()
                    if shownChronoline < numberOfChronolines {
                        chronoline = chronolineGenerator(
                            women: women,
                            numberOfWomen: 5,
                            x: geo.size.width / 2,
                            height: geo.size.height
                        )
                        timeLeft = chronolineTotalTime
                    }
                    showTimer = false
                }) {
                    Text("Submit")
                        .fontWeight(.bold)
                }
                .importantButtonStyle()
                Spacer()
            }
            .onReceive(timer) { _ in
                timeLeft -= 1
                if timeLeft < 0 {
                    timer.upstream.connect().cancel()
                    progress += 1.0 / Float(numberOfChronolines)
                    showTimer = false
                    shownChronoline += 1
                    timeLeft = chronolineTotalTime
                    scoreIfSorted()
                    if shownChronoline < numberOfChronolines {
                        chronoline = chronolineGenerator(
                            women: women,
                            numberOfWomen: 5,
                            x: geo.size.width / 2,
                            height: geo.size.height
                        )
                        timeLeft = chronolineTotalTime
                    }
                    showTimer = false
                }
            }
        }
    }
    
    func scoreIfSorted() {
        var mistakenWomenList: [ChronolineMismatch] = []
        for i in 0..<chronoline.cards.count {
            if chronoline.sortedYears[i] == chronoline.cards[i].woman.birthYear.localized {
                correctAnswers += 1
            } else {
                mistakenWomenList.append(ChronolineMismatch(
                    woman: chronoline.cards[i].woman,
                    wrongYear: chronoline.sortedYears[i]
                ))
            }
        }
        mistakes.append(
            ChronolineMistake(chronolineNumber: shownChronoline, mismatches: mistakenWomenList)
        )
    }
}
//struct TimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChronolineView()
//    }
//}
