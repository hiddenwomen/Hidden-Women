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
    var woman: Woman
    let id = UUID()
}

struct Objetos {
    var objetos: [Objeto]
}

struct ChronolineView: View {
    @State var objetos: [Objeto] = crea()
    @State var dragging: Int? = nil
    
    static func crea() -> [Objeto] {
        let o: [Objeto] = fullChronolineGenerator(women: women, numberOfWomen: 5, height: UIScreen.height, x: UIScreen.width / 2)
        return o
    }
    
    func reordena(noTocar: Int?) {
        let ordenados = objetos.sorted(by: {$0.pos.y < $1.pos.y} )
        var y: CGFloat = 25
        for ordenado in ordenados {
            for i in 0..<objetos.count {
                if i != noTocar && ordenado.woman.name == objetos[i].woman.name {
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
                ChronoWomanView(woman: objetos[i].woman)
                        .frame(width: 200, height: 100)
                        .shadow(radius: dragging == i ? 10 : 0)
                    .zIndex(dragging == i ? 1000 : 0)
                .position(objetos[i].pos)
                .gesture(
                    DragGesture()
                        .onChanged { drag in
                            
                            dragging = i
                            withAnimation(.spring()) {
                                objetos[i].pos = drag.location
                                reordena(noTocar: i)
                            }
                        }
                        .onEnded { drag in
                            dragging = nil
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
