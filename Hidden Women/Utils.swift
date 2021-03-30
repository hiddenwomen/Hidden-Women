//
//  Utils.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 19/3/21.
//

import Foundation
import SwiftUI

// Screen Size
let screenSize: CGRect = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

// Localized access to dictionaries with language keys
extension Dictionary where Key == String {
    var localized: Value {
        let key =  self.keys.contains(language) ? language : "en"
        return self[key]!
    }
}


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

//from: https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
extension String {
    func isValidEmail() -> Bool {
            // here, `try!` will always succeed because the pattern is valid
            let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        }
}

// from: https://www.advancedswift.com/resize-uiimage-no-stretching-swift/
extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        return scaledImage
    }
}
