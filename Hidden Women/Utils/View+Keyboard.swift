//
//  View+Keyboard.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/4/21.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
