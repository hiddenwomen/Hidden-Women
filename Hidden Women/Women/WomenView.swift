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
    @AppStorage ("userID") var userID = ""
    @State var showError = false
    @State var errorMessage = ""
    @State var showBanner: Bool = false
    
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
                                if userID != "" {
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
                                            updateFavourites(userID: userID, profile: profile) { error in
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
            if showBanner {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Only three favourites")
                                .bold()
                            Text("You can only select three Hiden Women as your favourites.")
                                .font(Font.system(size: 15))
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(Color("Morado"))
                    .cornerRadius(8)
                    Spacer()
                }
                .padding()
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        showBanner = false
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            showBanner = false
                        }
                    }
                }
            }
        }
    }
}

struct WomenView_Previews: PreviewProvider {
    static var previews: some View {
        WomenView()
    }
}
