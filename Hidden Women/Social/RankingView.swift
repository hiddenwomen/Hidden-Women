//
//  RankingView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 27/3/21.
//

import SwiftUI

struct RankingView: View {
    @EnvironmentObject var profile: Profile
    @State var rankedPeople: [Profile] = []
    
    var body: some View {
        List(Array(rankedPeople.enumerated()), id: \.0) { (i, person) in
                HStack {
                    Text("\(i + 1)")
                        .font(.largeTitle)
                        .foregroundColor(Color("Turquesa"))
                    Text("\(person.name): \(person.points)")
            }
        }
        .onAppear {
            rankedPeople = Array(profile.friends)
            rankedPeople.append(profile)
            rankedPeople.sort(by: {$0.points > $1.points})
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView()
    }
}
