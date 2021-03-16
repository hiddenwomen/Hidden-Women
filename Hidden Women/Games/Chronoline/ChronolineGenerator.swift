//
//  ChronolineGenerator.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 14/3/21.
//

import Foundation
import SwiftUI

func fullChronolineGenerator(women: [Woman], numberOfWomen: Int, height: CGFloat, x: CGFloat)-> Chronoline {
    var indices: Set<Int> = Set()
    var objetos: [Card] = []
    
    while indices.count < numberOfWomen {
        indices.insert((0..<women.count).randomElement()!)
    }
    for (j, i) in indices.enumerated() {
        objetos.append(Card(pos: CGPoint(x: x, y: 0.1 * height + 0.7 * height / CGFloat(numberOfWomen) * CGFloat(j)), woman: women[i]))
    }
    return Chronoline(cards: objetos)
}

func fullMultipleChronolineGenerator(women: [Woman], numberOfWomen: Int, height: CGFloat, x: CGFloat, numberOfChronolines: Int) -> [Chronoline] {
    var chronolines: [Chronoline] = []
    for i in 0..<numberOfChronolines {
        chronolines.append(fullChronolineGenerator(women: women, numberOfWomen: numberOfWomen, height: height, x: x))
    }
    return chronolines
}
