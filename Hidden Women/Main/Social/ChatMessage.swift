//
//  ChatMessage.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 8/4/21.
//

import Foundation

struct ChatMessage {
    let author: String
    let text: String
    let time: Int
    
    func toDict() -> [String: String] {
        return [
            "author": author,
            "text": text,
            "time": String(time)
        ]
    }
    
    static func from(dict: [String: String]) -> ChatMessage {
        return ChatMessage(
            author: dict["author"] ?? "",
            text: dict["text"] ?? "",
            time: Int(dict["time"] ?? "") ?? 0
        )
    }
}
