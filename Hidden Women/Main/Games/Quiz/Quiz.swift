//
//  Quiz.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 11/3/21.
//

import Foundation

struct Quiz: Hashable {
    let picture: String
    let question: String
    let answers: [String]
    let correctAnswer: Int
}
