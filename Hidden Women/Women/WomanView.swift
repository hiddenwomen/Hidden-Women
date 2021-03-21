//
//  WomanView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 9/3/21.
//

import SwiftUI


struct PictureView: View {
    @Binding var picture: String
    @Binding var name: String
    
    var body: some View {
        Image(picture)
            .resizable()
            .aspectRatio(contentMode: .fit)
        Text(name)
            .fontWeight(.bold)
    }
}

struct WomanView: View {
    let woman: Woman
    @State var showPicture: Bool = false
    @State var shownPicture: String = ""
    @State var shownName: String = ""
    @State var showAchievements: Bool = true
    @State var showAwards: Bool = true
    
    var body: some View {
        VStack(alignment: .center) {
            Text(woman.name)
                .font(.title)
                .fontWeight(.bold)
            Text("\(woman.birthYear.localized) - \(woman.deathYear.localized)")
            Text(woman.nationalities.localized.joined(separator: ", "))
            GeometryReader {geo in
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        Rectangle()
                            .frame(
                                width: (geo.size.width-150-20)/2,
                                height: 0
                            )
                        ForEach(woman.pictures, id: \.self) { picture in
                            Image(picture)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 200)
                                .onTapGesture {
                                    shownPicture = picture
                                    shownName = woman.name
                                    showPicture = true
                                }
                        }
                        Rectangle()
                            .frame(
                                width: (geo.size.width-150-20)/2,
                                height: 0
                            )
                    }
                }
            }
            .frame(maxHeight: 210)
            Text(woman.fields.localized.joined(separator: ", "))
                .fontWeight(.bold)
            Divider()
            ScrollView {
                DisclosureGroup(
                    isExpanded: $showAchievements,
                    content: {
                        ForEach(woman.achievements.localized, id:\.self) { achievement in
                            Text(achievement)
                        }
                    },
                    label: {
                        Text("Main achievements")
                            .fontWeight(.bold)
                            .onTapGesture {
                                withAnimation(.default) {
                                    showAchievements.toggle()
                                }
                            }
                    }
                )
                .padding(.horizontal)
                if woman.awards.localized.count > 0 {
                    DisclosureGroup(
                        isExpanded: $showAwards,
                        content: {
                            ForEach(woman.awards.localized, id:\.self) { award in
                                Text(award)
                            }
                        },
                        label: {
                            Text("Awards")
                                .fontWeight(.bold)
                                .onTapGesture {
                                    withAnimation(.default) {
                                        showAwards.toggle()
                                    }
                                }
                        }
                    )
                    .padding(.horizontal)
                }
                Text(woman.bio.localized)
                    .padding()
                HStack {
                    Text("To know more, go to")
                    Link("Wikipedia",
                         destination: URL(string: "https://\(language).wikipedia.org/wiki/\(woman.wikipedia)")!
                    )
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPicture){
            VStack{
                PictureView(picture: $shownPicture, name: $shownName)
                    .padding()
                Spacer()
                Text("Swipe down to hide.")
            }
        }
    }
}

struct WomanView_Previews: PreviewProvider {
    static var previews: some View {
        //WomanView(woman: women.first(where: {$0.name=="Mae Jemison"})!)
        WomanView(woman: women.first(where: {$0.name=="Rosalyn Sussman Yalow"})!)
        //WomanView(woman: women.first(where: {$0.name=="Alice Ball"})!)
    }
}
