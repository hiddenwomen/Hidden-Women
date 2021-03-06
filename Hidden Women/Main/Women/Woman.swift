//
//  Woman.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 9/3/21.
//

import Foundation

struct Woman: Identifiable, Decodable {
    let name: [String: String]
    let pictures: [String]
    let bio: [String: String]
    let birthYear: [String: String]
    let deathYear: [String: String]
    let awards: [String: [String]]
    let fields: [String: [String]]
    let achievements: [String: [String]]
    let nationalities: [String: [String]]
    let wikipedia: [String: String]
    
    var id: String { name["en"]! }
    var birthYearAsInt: Int {
        let nums = (birthYear["en"] ?? "").filter({"0123456789".contains($0)})
        var number = Int(nums) ?? 0
        if (birthYear["en"] ?? "").contains("b") {
           number = -number
        }
        return number
    }
    
    var wikipediaUrl: String {
        if self.wikipedia.keys.contains(language) {
            return "https://\(language).wikipedia.org/wiki/\(self.wikipedia.localized)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        } else {
            return "https://en.wikipedia.org/wiki/\(self.wikipedia["en"] ?? "")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
    }
}


