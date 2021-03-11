//
//  WomanView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 9/3/21.
//

import SwiftUI


var language = Locale.current.languageCode ?? "en"

struct PictureView: View {
    @Binding var picture: String
    
    var body: some View {
        Image(picture)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct WomanView: View {
    let woman: Woman
    @State var showPicture: Bool = false
    @State var shownPicture: String = ""
    
    var body: some View {
        ScrollView{
            VStack {
                Text(woman.name)
                    .font(.title)
                Text("\(woman.birthYear) - \(woman.deathYear)")
                Text(woman.nationalities.localized.joined(separator: ", "))
                TabView {
                    ForEach(woman.pictures, id: \.self) { picture in
                        Image(picture)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 200)
                            .onTapGesture{
                                print("Foto: \(picture)")
                                shownPicture = picture
                                showPicture = true
                            }
                        
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                Text(woman.fields.localized.joined(separator: ", "))
                ForEach(woman.achievements.localized, id: \.self) { achievement in
                    Text(achievement)
                }
                Text(woman.awards.localized.joined(separator: ", "))
                Text(woman.bio.localized)
                Link("Wikipedia", destination: URL(string: "https://\(language).wikipedia.org/wiki/\(woman.wikipedia)")!)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showPicture){
            VStack{
                PictureView(picture: $shownPicture)
                    .padding()
                Spacer()
                Text("Swipe down to hide.")
            }
        }
    }
}

struct WomanView_Previews: PreviewProvider {
    static let name = "Marie Curie"
    static let dummy = Woman(name: "Name", pictures: ["logo"], bio: ["en": "Bio"], birthYear: "0", deathYear: "0", awards: ["en": ["award"]], fields: ["en": ["Field"]], achievements: ["en": ["Achievement"]], nationalities: ["en": ["Nationality"]], wikipedia: "Science,_technology,_engineering,_and_mathematics")
    
    static var testWoman: Woman {
        if let location = Bundle.main.url(forResource: "women", withExtension: "json") {
            do {
                let data = try Data(contentsOf: location)
                do{
                    let women = try JSONDecoder().decode([Woman].self, from: data)
                    return women.first(where: {$0.name == name}) ?? dummy
                } catch {
                    print("Error en el JSON: \(error)")
                    return dummy
                }
            } catch {
                print("Error en la lectura del JSON: \(error)")
                return dummy
            }
        } else {
            return dummy
        }
    }
    
    static var previews: some View {
        WomanView(woman: testWoman)
    }
}
