//
//  AboutUsView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 7/4/21.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("About us")
                    .font(.largeTitle)
                Image("logo_nombre")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                VStack (alignment: .leading){
                    Text("We are GIRLS4STEM, a team from Castellón, Spain, and we want to promote women visibility.")
                        .lineLimit(nil)
                        .padding(.vertical)
                    Text("We want to thank Technovation Girls for empowering young girls like us.")
                        .lineLimit(nil)
                        .padding(.bottom)
                }
                Link(destination: URL(string: "https://technovationchallenge.org/")!) {
                    Image("technovationLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
                VStack (alignment: .leading){
                    Text("We would also like to thank these institutions for their support:")
                        .lineLimit(nil)
                        .padding(.vertical)
                }
                Link(destination: URL(string: "http://isonomia.uji.es/")!) {
                    Image("isonomiaLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
                .padding(.vertical)
                Link(destination: URL(string: "https://www.uji.es/")!) {
                    Image("ujiLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
                .padding(.vertical)
                Link(destination: URL(string: "http://www.if.uji.es/")!) {
                    Image("IFLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
                .padding(.vertical)
            }
            .padding()
        }
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
