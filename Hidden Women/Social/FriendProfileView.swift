//
//  FriendProfileView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 2/4/21.
//

import SwiftUI

struct FriendProfileView: View {
    let friendProfile: Profile
    let friendRequestButton: Bool
    @EnvironmentObject var profile: Profile
    @State var showBanner: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView{
                VStack {
                    NavigationLink(destination: ChatView(friendId: friendProfile.userId)) {
                            Text("Send a message")
                    }
                    Image(uiImage: friendProfile.picture ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 200, height: 200)
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
                    if friendRequestButton {
                        Button(action: {
                            var friendUserId = ""
                            getUserId(forEmail: friendProfile.email, onError: {error in}) { snapshot in
                                friendUserId = snapshot["userId"] as? String ?? ""
                                if friendUserId != "" {
                                    sendFriendRequest(destinationId: friendUserId, withMyProfile: profile, onError: {error in})
                                    showBanner = true
                                }
                            }
                        }) {
                            Text("Send friend request")
                                .fontWeight(.bold)
                                .importantButtonStyle()
                        }
                    }
                    if friendProfile.favourites.count > 0 {
                        VStack (alignment: .leading){
                            Text("Favourite hidden women:")
                                .font(.title)
                            ForEach(friendProfile.favourites, id: \.self) { favourite in
                                HStack {
                                    Image(women.filter({ $0.name["en"] == favourite }).map{$0.pictures[0]}.first ?? "")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75)
                                    Text(women.filter{ $0.name["en"] == favourite }.map{$0.name.localized}.first ?? "")
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            if showBanner {
                BannerView(
                    title: "Friend request sent",
                    text: "The user can accept of reject your request."
                ) {
                    showBanner = false
                }
            }
        }
    }
}

//struct FriendProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendProfileView()
//    }
//}
