//
//  Woman.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 9/3/21.
//

import Foundation

struct Woman: Identifiable, Decodable {
    let name: String
    let pictures: [String]
    let bio: [String: String]
    let birthYear: String
    let deathYear: String
    let awards: [String: [String]]
    let fields: [String: [String]]
    let achievements: [String: [String]]
    let nationalities: [String: [String]]
    let wikipedia: String
    
    var id: String { name }
}

extension Dictionary where Key == String {
    var localized: Value {
        let key =  self.keys.contains(language) ? language : "en"
        return self[key]!
    }
}
