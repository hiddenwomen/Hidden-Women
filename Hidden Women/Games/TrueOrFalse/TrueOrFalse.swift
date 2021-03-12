//
//  TrueOrFalse.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 12/3/21.
//

import Foundation

struct TrueOrFalse: Hashable, Equatable  {
    let picture: String
    let question: String
    let correct: Bool
    static func ==(left: TrueOrFalse, right: TrueOrFalse) -> Bool{
        return left.question == right.question && left.correct == right.correct
    }
}
