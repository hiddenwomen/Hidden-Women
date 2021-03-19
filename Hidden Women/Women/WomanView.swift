//
//  WomanView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 9/3/21.
//

import SwiftUI


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
                            shownPicture = picture
                            showPicture = true
                        }
                    
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            Text(woman.fields.localized.joined(separator: ", "))
                .fontWeight(.bold)
            ScrollView {
                ForEach(woman.achievements.localized, id: \.self) { achievement in
                    Text(achievement)
                }
                Text(woman.awards.localized.joined(separator: ", "))
                Text(woman.bio.localized)
                Link("Wikipedia", destination: URL(string: "https://\(language).wikipedia.org/wiki/\(woman.wikipedia)")!)
                
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
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
    static var previews: some View {
        WomanView(woman: women[0])
    }
}
