//
//  ChronolineView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 12/3/21.
//

import SwiftUI
extension UIScreen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
}

struct Card: Identifiable {
    var pos: CGPoint
    var woman: Woman
    let id = UUID()
}

struct Chronoline {
    var cards: [Card]
}

struct ChronolineView: View {
    @State var chronoline: Chronoline
    @State var dragging: Int? = nil
    @Binding var shownChronoline: Int
    @Binding var progress: Float
    @Binding var correctAnswers: Int
    let numberOfChronolines: Int
    
    
    func reordena(noTocar: Int?) {
        let ordenados = chronoline.cards.sorted(by: {$0.pos.y < $1.pos.y} )
        var y: CGFloat = 0.1 * UIScreen.height
        for ordenado in ordenados {
            for i in 0..<chronoline.cards.count {
                if i != noTocar && ordenado.woman.name == chronoline.cards[i].woman.name {
                    chronoline.cards[i].pos.y = y
                    break
                }
            }
            y += 0.7 * UIScreen.height / CGFloat(chronoline.cards.count)
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(0..<chronoline.cards.count) { i in
                    ChronoWomanView(woman: chronoline.cards[i].woman)
                            .frame(width: 200, height: 100)
                            .shadow(radius: dragging == i ? 10 : 0)
                        .zIndex(dragging == i ? 1000 : 0)
                        .position(chronoline.cards[i].pos)
                    .gesture(
                        DragGesture()
                            .onChanged { drag in
                                
                                dragging = i
                                withAnimation(.spring()) {
                                    chronoline.cards[i].pos = drag.location
                                    reordena(noTocar: i)
                                }
                            }
                            .onEnded { drag in
                                dragging = nil
                                withAnimation(.spring()) {
                                    chronoline.cards[i].pos = CGPoint(x: UIScreen.width / 2, y: drag.location.y)
                                    reordena(noTocar: nil)
                                }
                            }
                    )
                }
            }
            Button(action: {
                progress += 1.0 / Float(numberOfChronolines)
                var isSorted = true
                for i in 0..<chronoline.cards.count - 1 {
                    if chronoline.cards[i].woman.birthYear > chronoline.cards[i + 1].woman.birthYear{
                        isSorted = false
                    }
                }
                if isSorted {
                    correctAnswers += 1
                }
                shownChronoline += 1
                print(shownChronoline)
            }) {
                Text("Submit")
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40))
                    .foregroundColor(Color.white)
                    .background(Color("Morado"))
                    .cornerRadius(10)
            }
        }
    }
}

//struct TimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChronolineView()
//    }
//}
