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
            List(women) { woman in
                NavigationLink(destination: WomanView(woman: woman)) {
                    HStack {
                        Image(woman.pictures[0])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 3, x: 3, y: 3)
                        VStack (alignment: .leading){
                            Text(woman.name)
                            Text(woman.fields.localized.joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 10)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct WomenView_Previews: PreviewProvider {
    static var previews: some View {
        WomenView()
    }
}
