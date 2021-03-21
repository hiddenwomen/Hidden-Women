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
    let birthYear: [String: String]
    let deathYear: [String: String]
    let awards: [String: [String]]
    let fields: [String: [String]]
    let achievements: [String: [String]]
    let nationalities: [String: [String]]
    let wikipedia: String
    
    var id: String { name }
    var birthYearAsInt: Int {
        let nums = (birthYear["en"] ?? "").filter({"0123456789".contains($0)})
        return Int(nums) ?? 0
        //TODO: when bC., the number is negative
    }
}


