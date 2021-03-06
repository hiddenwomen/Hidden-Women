//
//  WomenView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 9/3/21.
//

import SwiftUI

struct WomenView: View {
    @State var searchText: String = ""
    @EnvironmentObject var profile: Profile
    @State var showError = false
    @State var errorMessage = ""
    @State var showBanner: Bool = false
    @State var showEasterEgg: Bool = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    SearchBarView(searchText: $searchText)
                    List(women.filter { woman in
                        if searchText == "" {
                            return true
                        } else {
                            return woman.name.localized.lowercased().contains(searchText.lowercased())
                        }
                    }) { woman in
                        NavigationLink(destination: WomanView(woman: woman)) {
                            HStack {
                                if !profile.isGuest {
                                    Image(systemName: profile.favourites.contains(woman.name["en"] ?? "") ? "heart.fill" : "heart")
                                        .foregroundColor(Color("Morado"))
                                        .onTapGesture{
                                            if profile.favourites.contains(woman.name["en"] ?? ""){
                                                profile.favourites.removeAll{ $0 == woman.name["en"] }
                                            } else {
                                                if profile.favourites.count < 3 {
                                                    profile.favourites.append(woman.name["en"] ?? "")
                                                } else {
                                                    showBanner = true
                                                }
                                            }
                                            profile.updateFavourites() { error in
                                                errorMessage = error.localizedDescription
                                                showError = true
                                            }
                                        }
                                }
                                Image(woman.pictures[0])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .shadow(radius: 3, x: 3, y: 3)
                                VStack (alignment: .leading){
                                    Text(woman.name.localized)
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
                .alert(isPresented: $showError) {
                    Alert(
                        title: Text("Error setting favorites"),
                        message: Text(errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .padding(0)
            if showBanner {
                BannerView(
                    title: "Only three favourites",
                    text: "You can only select three Hidden Women as your favourites."
                ) {
                    showBanner = false
                }
            }
        }
        .sheet(isPresented: $showEasterEgg) {
            Text("You found an easter egg!")
        }

    }
}

struct WomenView_Previews: PreviewProvider {
    static var previews: some View {
        WomenView()
    }
}
