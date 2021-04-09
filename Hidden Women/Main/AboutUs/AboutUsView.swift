//
//  AboutUsView.swift
//  Hidden Women
//
//  Created by Mireia Belinchón Castillo on 7/4/21.
//

import SwiftUI

struct AboutUsView: View {
    @EnvironmentObject var profile: Profile
    @State var userComment: String = ""
    @State var showBanner: Bool = false
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Text("About us")
                            .font(.largeTitle)
                        HStack {
                            Spacer()
                            Image("logo_nombre")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                            Spacer()
                        }
                        Text("We are GIRLS4STEM, a team from Castellón, Spain, and we want to promote women visibility.")
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical)
                            .layoutPriority(1)
                    }
                    Group {
                        Text("Do you know a woman who should be added to our Hidden Women list? Do you have some suggestion? Do you like the app? Tell us:")
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .layoutPriority(1)
                        VStack (alignment: .center){
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color("Hueso"))
                                if userComment == "" {
                                    Text("Write you comments here...")
                                        .foregroundColor(Color(UIColor.placeholderText))
                                        .frame(alignment: .topLeading)
                                }
                                TextEditor(text: $userComment)
                                    .foregroundColor(Color("Morado"))
                                    .lineLimit(5)
                                    .frame(minHeight: 24)
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    profile.sendFeedback(text: userComment, onError: { error in })
                                    userComment = ""
                                    showBanner = true
                                }) { //TODO: Action para enviar el comentario
                                    Text("Tell us what you think!")
                                        .bold()
                                }
                                .importantButtonStyle()
                                .disabled(userComment == "")
                                Spacer()
                            }
                        }
                    }
                    
                    Group {
                        VStack (alignment: .leading){
                            Text("We want to thank Technovation Girls for empowering young girls like us.")
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.vertical)
                                .layoutPriority(1)
                        }
                        Link(destination: URL(string: "https://technovationchallenge.org/")!) {
                            HStack {
                                Spacer()
                                Image("technovationLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                Spacer()
                            }
                        }
                        
                        
                        VStack (alignment: .leading){
                            Text("We would also like to thank these institutions for their support:")
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.vertical)
                                .layoutPriority(1)
                        }
                        Link(destination: URL(string: "http://isonomia.uji.es/")!) {
                            HStack {
                                Spacer()
                                Image("isonomiaLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                Spacer()
                            }
                        }
                        .padding(.vertical)
                        Link(destination: URL(string: "https://www.uji.es/")!) {
                            HStack {
                                Spacer()
                                Image("ujiLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                Spacer()
                            }
                        }
                        .padding(.vertical)
                        Link(destination: URL(string: "http://www.if.uji.es/")!) {
                            HStack {
                                Spacer()
                                Image("IFLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                Spacer()
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .padding()
            }
            if showBanner {
                BannerView(title: "Thank you!", text: "Your comment has been sent to GIRLS4STEM.", closeBanner: { showBanner = false })
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
