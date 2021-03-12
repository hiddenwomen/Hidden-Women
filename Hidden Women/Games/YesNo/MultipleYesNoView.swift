//
//  MultipleYesNoView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 12/3/21.
//

import SwiftUI

struct MultipleYesNoView: View {
    @State var correctAnswers: Int = 0
    @State var shownYesNo: Int = 0
    
    let yesNos: [YesNo] = [
        YesNo(picture: "Curie1", question: "blablabal", correct: true),
        YesNo(picture: "Curie2", question: "blibliblbi", correct: false)
    ]
    
    var body: some View {
        Group {
            if shownYesNo == yesNos.count {
                VStack {
                    Text("Points: \(correctAnswers)")
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
            if shownYesNo != yesNos.count {
                VStack {
                    Text("\(shownYesNo+1)/\(yesNos.count)")
                    YesNoView(shownYesNo: $shownYesNo,
                              correctAnswers: $correctAnswers,
                              yesNo: yesNos[shownYesNo]
                     )
                }
            }
        }
    }
}

//struct MultipleYesNoView_Previews: PreviewProvider {
//    static var previews: some View {
//        MultipleYesNoView()
//    }
//}
