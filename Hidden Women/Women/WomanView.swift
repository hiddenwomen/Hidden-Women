//
//  WomanView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 9/3/21.
//

import SwiftUI

struct WomanView: View {
    let woman: Woman
    
    var body: some View {
        VStack{
            Text(woman.name)
            Text(woman.birthYear)
        }
    }
}

struct WomanView_Previews: PreviewProvider {
    static let testWoman = Woman(name: "Ada", birthYear: "1900")
    
    static var previews: some View {
        WomanView(woman: testWoman)
    }
}
