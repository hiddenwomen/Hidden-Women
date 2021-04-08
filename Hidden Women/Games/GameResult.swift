//
//  GameResult.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 8/4/21.
//

import Foundation


struct GameResult: Identifiable {
    let date: Int
    let gameType: String
    let points: Int
    let id: UUID = UUID()
    
    func toDict() -> [String: Any] {
        return [
            "date": date,
            "gameType": gameType,
            "points": points
        ]
    }
    
    static func fromDict(dict: [String: Any]) -> GameResult {
        GameResult(
            date: dict["date"] as? Int ?? 0,
            gameType: dict["gameType"] as? String ?? "Error",
            points: dict["points"] as? Int ?? 0
        )
    }
}

extension Array where Element == GameResult {
    func points(limit: Int) -> Int {
        return self.filter{$0.date > limit}.map{$0.points}.reduce(0, +)
    }
}
