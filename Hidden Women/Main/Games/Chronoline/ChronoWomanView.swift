//
//  ChronoWomanView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 14/3/21.
//

import SwiftUI

struct ChronoWomanView: View {
    let woman: Woman
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("Turquesa"))
            HStack {
                Image(woman.pictures.randomElement()!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width/3, height: 0.8 * height)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                VStack (alignment: .leading) {
                    Text(woman.name.localized)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text(woman.fields.localized.joined(separator: ", "))
                        .font(.caption)
                }
            }
            .frame(width: width, height: height, alignment: .leading)
        }
    }
}

struct ChronoWomanView_Previews: PreviewProvider {
    static var woman = women[0]
    
    static var previews: some View {
        ChronoWomanView(woman: woman, width: 200, height: 100)
    }
}
