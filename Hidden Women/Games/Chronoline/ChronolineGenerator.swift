//
//  ChronolineGenerator.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 14/3/21.
//

import Foundation
import SwiftUI

func chronolineGenerator(women: [Woman], numberOfWomen: Int, x: CGFloat, height: CGFloat) -> Chronoline {
    return Chronoline(
        women: Array(women.shuffled()[0..<min(women.count, numberOfWomen)]),
        x: x,
        height: height)
}
