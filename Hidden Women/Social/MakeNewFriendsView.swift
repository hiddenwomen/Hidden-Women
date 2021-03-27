//
//  MakeNewFriendsView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 27/3/21.
//

import SwiftUI

struct MakeNewFriendsView: View {
    @State var email: String = ""
    
    var body: some View {
        VStack {
            TextField("Email...", text: $email)
            Button(action: {
                
            } ){
                Text("Send friend request")
            }
        }
        .onChange(of: email) { newEmail in
            print("CAMBIA \(newEmail)")
        }
        
    }
}

struct MakeNewFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        MakeNewFriendsView()
    }
}
