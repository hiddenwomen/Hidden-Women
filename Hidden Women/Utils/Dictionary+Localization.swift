//
//  Dictionary+Localization.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/4/21.
//

import Foundation

// Localized access to dictionaries with language keys
extension Dictionary where Key == String {
    var localized: Value {
        let key =  self.keys.contains(language) ? language : "en"
        return self[key]!
    }
}
