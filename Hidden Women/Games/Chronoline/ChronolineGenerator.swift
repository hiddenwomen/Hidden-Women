//
//  ChronolineGenerator.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 14/3/21.
//

import Foundation
import SwiftUI

func fullChronolineGenerator(women: [Woman], numberOfWomen: Int, height: CGFloat, x: CGFloat)-> [Objeto] {
    var indices: Set<Int> = Set()
    var objetos: [Objeto] = []
    
    while indices.count < numberOfWomen {
        indices.insert((0..<women.count).randomElement()!)
    }
    for i in indices {
        objetos.append(Objeto(pos: CGPoint(x: x, y: height / CGFloat(numberOfWomen) * CGFloat(i)), woman: women[i]))
        print("\(String(describing: objetos.last?.pos))")
    }
    return objetos
}
