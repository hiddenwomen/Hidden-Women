//
//  GamesView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/3/21.
//

import SwiftUI

struct GamesView: View {
    @AppStorage ("userID") var userID = ""
    @Binding var currentPage: Page
    
    var body: some View {
        VStack {
            Text(userID)
            Button(action: {
                userID = ""
                currentPage = .login
                
            }) {
                Text("Sign out")
            }
        }
    }
}

struct GamesView_Previews: PreviewProvider {
    @State static var page: Page = .main
    static var previews: some View {
        GamesView(currentPage: $page)
    }
}
