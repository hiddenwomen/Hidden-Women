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
            Text("Welcome, guest!")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color("Morado"))
            Image("logo_nombre")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text("Vas a usar la aplicación como invitada. La funcionalidad de red social no estará activada. Para disfrutar de la aplicación al completo has de registrarte.")
                .padding()
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
                currentPage = .signup
            }) {
                Text("Sign up now!")
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
