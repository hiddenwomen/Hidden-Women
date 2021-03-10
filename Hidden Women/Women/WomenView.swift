//
//  WomenView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 9/3/21.
//

import SwiftUI

struct WomenView: View {
    let women: [Woman]

    init() {
        if let location = Bundle.main.url(forResource: "women", withExtension: "json") {
            do {
                let data = try Data(contentsOf: location)
                do{
                    women = try JSONDecoder().decode([Woman].self, from: data)
                } catch {
                    women = []
                    print("Error en el JSON: \(error)")
                }
            } catch {
                women = []
                print("Error en la lectura del JSON: \(error)")
            }
        } else {
          women = []
        }
    }
    
    var body: some View {
        NavigationView {
            List(women){ woman in
                NavigationLink(destination: WomanView(woman: woman)) {
                    HStack {
                        Image(woman.pictures[0])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 40)
                        Text(woman.name)
                    }
                }
                    
            }
        }
    }
}

//struct WomenView_Previews: PreviewProvider {
//    static let testWomenList = [
//        Woman(name: "Ada", birthYear: "1900", pictures: ["Curie1"]),
//        Woman(name: "Pepa", birthYear: "2010", pictures: ["Curie2"])
//    ]
//
//    static var previews: some View {
//        WomenView(women: testWomenList)
//    }
//}
