//
//  RankingView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 27/3/21.
//

import SwiftUI

struct RankingView: View {
    @EnvironmentObject var profile: Profile
    @EnvironmentObject var rankingUpdater: RankingUpdater
    @State var rankedPeople: [Profile] = []
    
    var body: some View {
        VStack {
            List(Array(rankedPeople.enumerated()), id: \.0) { (i, person) in
                ZStack (alignment: .leading){
                    Rectangle()
                        .foregroundColor(person.email == profile.email ? Color("Hueso") : .white)
                    HStack {
                        Text("\(i + 1)")
                            .font(.largeTitle)
                            .foregroundColor(person.email == profile.email ? Color("Morado") : Color("Turquesa"))
                            .padding()
                        Image(uiImage: person.picture ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70)
                            .clipShape(Circle())
                        VStack (alignment: .leading){
                            Text("\(person.name)")
                                .font(.title)
                                .fontWeight(person.email == profile.email ? .bold : .regular)
                                .foregroundColor(person.email == profile.email ? Color("Morado") : .black)
                                .lineLimit(2)
                            Text(
                                String.localizedStringWithFormat(NSLocalizedString("Points: %@", comment: ""), String(person.points))
                            )
                        }
                    }
                }
            }
        }
        .onAppear {
            rankedPeople = Array(profile.friendProfiles.map{$0})
            rankedPeople.append(profile)
            rankedPeople.sort(by: {$0.points > $1.points})
            for person in rankedPeople {
                print("\(person.name): \(person.picture!.size)")
            }
        }
        .onChange(of: rankingUpdater.counter, perform: { _ in
            rankedPeople.sort(by: {$0.points > $1.points})
        })
    }
}

//struct RankingView_Previews: PreviewProvider {
//    static var previews: some View {
//        RankingView()
//    }
//}
