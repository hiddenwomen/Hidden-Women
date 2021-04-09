//
//  FriendProfileView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 2/4/21.
//

import SwiftUI

struct FriendProfileView: View {
    @EnvironmentObject var profile: Profile
    @ObservedObject var friendProfile: Profile
    let showFriendRequestButton: Bool
    @State var showBanner: Bool = false
    @State var favouriteHiddenWomen: Bool = false
    @Binding var notifications: [String]
    
    var body: some View {
        ZStack {
            ScrollView{
                VStack {
                    Image(uiImage: friendProfile.picture ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
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
                    if showFriendRequestButton {
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
                    if !showFriendRequestButton {
                        NavigationLink(destination: ChatView(
                                        friendId: friendProfile.userId,
                                        chat: Chat(aId: profile.userId, bId: friendProfile.userId),
                                        notifications: $notifications)
                        ) {
                            HStack {
                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                Text("Chat")
                            }
                            .font(.title)
                            .importantButtonStyle()
                            .padding()
                        }
                    }
                    if friendProfile.favourites.count > 0 {
                        DisclosureGroup (
                            isExpanded: $favouriteHiddenWomen,
                            content: {
                                VStack (alignment: .leading){
                                    ForEach(friendProfile.favourites, id: \.self) { favourite in
                                        HStack {
                                            Image(women.filter({ $0.name["en"] == favourite }).map{$0.pictures[0]}.first ?? "")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 75)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                            Text(women.filter{ $0.name["en"] == favourite }.map{$0.name.localized}.first ?? "")
                                        }
                                    }
                                }
                                .padding()
                            },
                            label: {
                                Text("Favourite Hidden Women:")
                                    .font(.title)
                                    .onTapGesture {
                                        favouriteHiddenWomen.toggle()
                                    }
                            }
                        )
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
