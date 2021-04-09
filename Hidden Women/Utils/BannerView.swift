//
//  Utils.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 19/3/21.
//

import Foundation
import SwiftUI

struct BannerView: View {
    let title: String
    let text: String
    let closeBanner: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .bold()
                    Text(text)
                        .font(Font.system(size: 15))
                }
                Spacer()
            }
            .foregroundColor(Color.white)
            .padding(12)
            .background(Color("Morado"))
            .cornerRadius(8)
            Spacer()
        }
        .padding()
        .animation(.easeInOut)
        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
        .onTapGesture {
            withAnimation {
                closeBanner()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    closeBanner()
                }
            }
        }
    }
}
