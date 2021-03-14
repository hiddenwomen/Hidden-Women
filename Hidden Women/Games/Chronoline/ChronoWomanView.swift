//
//  ChronoWomanView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 14/3/21.
//

import SwiftUI

struct ChronoWomanView: View {
    let woman: Woman
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("Turquesa"))
            HStack {
                Image(woman.pictures.randomElement()!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 80)
                Text(woman.name)
            }
            .frame(width: 180, height: 90, alignment: .leading)
        }
    }
}

struct ChronoWomanView_Previews: PreviewProvider {
    static var woman = women[0]
    
    static var previews: some View {
        ChronoWomanView(woman: woman)
    }
}
