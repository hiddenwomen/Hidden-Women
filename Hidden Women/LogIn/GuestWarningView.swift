//
//  GuestWarningView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 11/3/21.
//

import SwiftUI

struct GuestWarningView: View {
    @AppStorage ("userID") var userID = ""
    @Binding var currentPage: Page
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button(action: {
                    userID = ""
                    currentPage = .main
            }) {
                Text("Continue")
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40))
                    .foregroundColor(Color.white)
                    .background(Color("Morado"))
                    .cornerRadius(10)
            }
            .padding()
            Button(action: {
                currentPage = .login
            }) {
                Text("Cancel")
                    .foregroundColor(Color("Morado"))
            }
        }
    }
}

struct GuestWarningView_Previews: PreviewProvider {
    @State static var currentPage: Page = .guest
    static var previews: some View {
        GuestWarningView(currentPage: $currentPage)
    }
}
