//
//  FriendProfileView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 2/4/21.
//

import SwiftUI

struct FriendProfileView: View {
    let friendProfile: Profile
    
    var body: some View {
        ScrollView{
            VStack {
                Image(uiImage: friendProfile.picture ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 300, height: 300)
                Text(friendProfile.name)
                    .fontWeight(.bold)
                Text(friendProfile.email)
                ZStack {
                    Circle()
                        .foregroundColor(Color("Turquesa"))
                        .frame(width: 125, height: 125)
                    VStack{
                        Text("\(friendProfile.points)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                        if friendProfile.points != 1 {
                            Text("points")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        } else {
                            Text("point")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                }
                VStack (alignment: .leading){
                    Text("Favourite hidden women:")
                        .font(.title)
                    ForEach(friendProfile.favourites, id: \.self) { favourite in
                        HStack {
                            Image(women.filter({ $0.name == favourite }).map{$0.pictures[0]}.first ?? "")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75)
                            Text(favourite)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

//struct FriendProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendProfileView()
//    }
//}
