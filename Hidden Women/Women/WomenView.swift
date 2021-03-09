//
//  WomenView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 9/3/21.
//

import SwiftUI

struct WomenView: View {
    let women: [Woman]
    
    var body: some View {
        NavigationView {
            List(women){ woman in
                NavigationLink(destination: WomanView(woman: woman)) {
                    Text(woman.name)
                }
                    
            }
        }
    }
}

struct WomenView_Previews: PreviewProvider {
    static let testWomenList = [
        Woman(name: "Ada", birthYear: "1900"),
        Woman(name: "Pepa", birthYear: "2010")
    ]
    
    static var previews: some View {
        WomenView(women: testWomenList)
    }
}
