//
//  ChronolineGenerator.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 14/3/21.
//

import Foundation
import SwiftUI

func chronolineGenerator(women: [Woman], numberOfWomen: Int, x: CGFloat, height: CGFloat) -> Chronoline {
    var indices: Set<Int> = Set()
    var selectedWomen: [Woman] = []
    
    while indices.count < numberOfWomen {
        indices.insert((0..<women.count).randomElement()!)
    }
    for i in indices {
        selectedWomen.append(women[i])
    }
    return Chronoline(women: selectedWomen, x: x, height: height)
}
