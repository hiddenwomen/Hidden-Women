//
//  FIndPeopleCardView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 10/4/21.
//

import SwiftUI

struct FIndPeopleCardView: View {
    @ObservedObject var friendProfile: Profile
    
    var body: some View {
        HStack {
            Image(uiImage: friendProfile.picture ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: 75, height: 75)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(friendProfile.name)
                    .font(.title)
                Text("Her favourite Hidden Women are: ")
                    .font(.caption) +
                    Text(friendProfile.favourites.joined(separator: ", "))
                        .font(.caption)
            }
        }
    }
}
