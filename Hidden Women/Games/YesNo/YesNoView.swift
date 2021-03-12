//
//  YesNoView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 12/3/21.
//

import SwiftUI

struct YesNoView: View {
    @Binding var shownYesNo: Int
    @Binding var correctAnswers: Int
    
    let yesNo: YesNo
    
    var body: some View {
        VStack {
            Image(yesNo.picture)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 200)
                .padding(.vertical)
            Text(yesNo.question)
            
            HStack {
                Spacer()
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("Turquesa"))
                            .frame(width: 100, height: 100)
                        Text("No")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    }
                }
                Spacer()
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("Morado"))
                            .frame(width: 100, height: 100)
                        Text("Yes")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    }
                }
                Spacer()
            }
            .padding(.top, 40)
        }
    }
}

//struct YesNoView_Previews: PreviewProvider {
//    static let yesNo = YesNo(picture: "Curie1", question: "hola", correct: true)
//    
//    static var previews: some View {
//        YesNoView(yesNo: yesNo)
//    }
//}
