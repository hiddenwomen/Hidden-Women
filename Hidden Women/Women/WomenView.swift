//
//  WomenView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 9/3/21.
//

import SwiftUI

struct WomenView: View {
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $searchText)
                List(women.filter { woman in
                    if searchText == "" {
                        return true
                    } else {
                        return woman.name.lowercased().contains(searchText.lowercased())
                    }
                }) { woman in
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
                .listStyle(PlainListStyle())
                .navigationBarHidden(true)
            }
        }
    }
}

struct WomenView_Previews: PreviewProvider {
    static var previews: some View {
        WomenView()
    }
}
