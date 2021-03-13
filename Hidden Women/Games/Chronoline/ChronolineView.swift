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

struct Objeto: Identifiable {
    var pos: CGPoint
    var number: String
    let id = UUID()
}

struct Objetos {
    var objetos: [Objeto]
}

struct ChronolineView: View {
    @State var objetos: [Objeto] = crea()
    
    static func crea() -> [Objeto] {
        var o: [Objeto] = []
        for i in 0..<5 {
            o.append(Objeto(pos: CGPoint(x: UIScreen.width / 2, y: 25 + 125 * CGFloat(i)), number: "\(i)"))
        }
        return o
    }
    
    func reordena(noTocar: Int?) {
        let ordenados = objetos.sorted(by: {$0.pos.y < $1.pos.y} )
        var y: CGFloat = 25
        for ordenado in ordenados {
            for i in 0..<objetos.count {
                if i != noTocar && ordenado.number == objetos[i].number {
                    objetos[i].pos.y = y
                    break
                }
            }
            y += 125
        }
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<objetos.count) { i in
                ZStack {
                    Circle()
                        .foregroundColor(.blue)
                        .frame(width: 100, height: 100)
                    Text(objetos[i].number)
                }
                .position(objetos[i].pos)
                .gesture(
                    DragGesture()
                        .onChanged { drag in
                            withAnimation(.spring()) {
                                objetos[i].pos = drag.location
                                reordena(noTocar: i)
                            }
                        }
                        .onEnded { drag in
                            withAnimation(.spring()) {
                                objetos[i].pos = CGPoint(x: UIScreen.width / 2, y: drag.location.y)
                                reordena(noTocar: nil)
                            }
                        }
                )
            }
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        ChronolineView()
    }
}
