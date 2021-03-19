//
//  Profile.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 18/3/21.
//

import Foundation
import SwiftUI

class Profile: ObservableObject {
    @Published var name: String
    @Published var email: String
    @Published var favourites: [String] = []
    @Published var picture: UIImage? = UIImage(named: "unknown")
    
    init(name: String = "", email: String = "") {
        self.name = name
        self.email = email
    }
}
