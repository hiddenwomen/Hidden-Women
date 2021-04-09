//
//  ViewModifiers.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/4/21.
//

import Foundation
import SwiftUI

// ImportantButton Style modifier
struct ImportantButtonStyle: ViewModifier {
    let background: Color
    
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40))
            .foregroundColor(Color.white)
            .background(background)
            .cornerRadius(10)
    }
}

extension View {
    func importantButtonStyle(_ background: Color = Color("Morado")) -> some View {
        self.modifier(ImportantButtonStyle(background: background))
    }
}
