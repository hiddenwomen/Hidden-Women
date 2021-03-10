//
//  WomanView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 9/3/21.
//

import SwiftUI


var language = Locale.current.languageCode ?? "en"

struct WomanView: View {
    let woman: Woman
    
    var body: some View {
        VStack{
            Text(woman.name)
                .font(.title)
            Text("\(woman.birthYear) - \(woman.deathYear)")
            Text(woman.nationalities.localized.joined(separator: ", "))
            Image(woman.pictures[0])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 200)
            Text(woman.fields.localized.joined(separator: ", "))
            ForEach(woman.achievements.localized, id: \.self) { achievement in
                Text(achievement)
            }
            Text(woman.awards.localized.joined(separator: ", "))
            Text(woman.bio.localized)
            Link("Wikipedia", destination: URL(string: "https://\(language).wikipedia.org/wiki/\(woman.wikipedia)")!)
        }
    }
}

struct WomanView_Previews: PreviewProvider {
    static let testWoman: Woman = Woman(
        name: "Ada Lovelace",
        pictures: ["Lovelace1", "Lovelace2"],
        bio: [
            "en": "She was an English mathematician and writer, chiefly known for her work on Charles Babbage's proposed mechanical general-purpose computer, the Analytical Engine. She is believed by some to be the first to recognise that the machine had applications beyond pure calculation, and to have published the first algorithm intended to be carried out by such a machine. As a result, she is often regarded as the first to recognise the full potential of computers and as one of the first computer programmers.",
            "es": "Fue una matemática y escritora inglesa, principalmente conocida por su trabajo en la computadora mecánica de propósito general propuesta por Charles Babbage, la Máquina Analítica. Algunos creen que fue la primera en reconocer que la máquina tenía aplicaciones más allá del cálculo puro, y publicó el primer algoritmo destinado a ser llevado a cabo por dicha máquina. Como resultado, a menudo se la considera la primera en reconocer todo el potencial de las computadoras y como una de las primeras programadoras de computadoras.",
            "ca": "Va ser una matemàtica i escriptora anglesa, principalment coneguda pel seu treball en la computadora mecànica de propòsit general proposta per Charles Babbage, la Màquina Analítica. Alguns creuen que va ser la primera a reconéixer que la màquina tenia aplicacions més enllà del càlcul pur, i va publicar el primer algorisme destinat a ser dut a terme per aquesta màquina. Com a resultat, sovint se la considera la primera a reconéixer tot el potencial de les computadores i com una de les primeres programadores de computadores."
        ],
        birthYear: "1815",
        deathYear: "1852",
        awards: [
            "en": ["Award 1"],
            "es": ["Premio 1"],
            "ca": ["Premi 1"],
        ],
        fields: [
            "en": [
              "Mathematician",
              "Writer",
              "Programmer"
            ],
            "es": [
              "Matemática",
              "Escritora",
              "Programadora"
            ],
            "ca": [
              "Matemàtica",
              "Escritora",
              "Programadora"
            ]
        ],
        achievements: [
            "en": [
              "First computer programmer"
            ],
            "es": [
              "Primera persona en programar una computadora"
            ],
            "ca": [
              "Primera persona en programar una computadora"
            ]
        ],
        nationalities: [
            "en": [
              "Brittish"
            ],
            "es": [
              "Británica"
            ],
            "ca": [
              "Britànica"
            ]
        ],
        wikipedia: "Ada_Lovelace")
    
    static var previews: some View {
        WomanView(woman: testWoman)
    }
}
