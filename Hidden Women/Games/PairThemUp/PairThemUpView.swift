//
//  PairThemUpView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 4/4/21.
//

import SwiftUI

struct WomanPicture {
    let pictureName: String
    var startPosition: CGPoint
    var position: CGPoint = CGPoint(x: 0, y: 0)
    var zIndex: Double = 1
    var coveringWomanName: String? = nil
    
    init(pictureName: String, x: CGFloat, y: CGFloat) {
        self.pictureName = pictureName
        self.startPosition = CGPoint(x: x, y: y)
        self.position = CGPoint(x: x, y: y)
    }
    
    func squaredDistanceTo(womanName: WomanName)-> CGFloat {
        let dx = self.position.x - womanName.position.x
        let dy = self.position.y - womanName.position.y
        return dx * dx + dy * dy
    }
}

struct WomanName {
    let name: String
    let position: CGPoint
    var backgroundColor: Color = Color.white
    var isCovered: Bool = false
}

struct PairThemUpView: View {
    @State var womanPicture: [WomanPicture]
    @State var womanName: [WomanName]
    @State var activateSubmit: Bool = false
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("Hueso"))
                    ForEach(0..<womanName.count) { i in
                        Circle()
                            .strokeBorder(Color("Morado"), lineWidth: 3)
                            .background(Circle().foregroundColor(womanName[i].backgroundColor))
                            .frame(width: geo.size.width / 4 + 10)
                            .position(womanName[i].position)
                        Text(womanName[i].name)
                            .position(womanName[i].position)
                            .zIndex(1000)
                    }
                    ForEach(0..<womanPicture.count) { i in
                        Image(womanPicture[i].pictureName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width / 4)
                            .clipShape(Circle())
                            .position(x: womanPicture[i].position.x, y: womanPicture[i].position.y)
                            .zIndex(womanPicture[i].zIndex)
                            .gesture(
                                DragGesture()
                                    .onChanged { drag in
                                        activateSubmit = false
                                        withAnimation(.default) {
                                            womanPicture[i].zIndex = womanPicture.map{$0.zIndex}.max()! + 0.0001
                                            if let name = womanPicture[i].coveringWomanName {
                                                for j in 0..<womanName.count {
                                                    if womanName[j].name == name {
                                                        womanName[j].isCovered = false
                                                        break
                                                    }
                                                }
                                            }
                                            womanPicture[i].coveringWomanName = nil
                                            womanPicture[i].position = drag.location
                                            for j in 0..<womanName.count {
                                                if !womanName[j].isCovered {
                                                    if womanPicture[i].squaredDistanceTo(womanName: womanName[j]) < 2500{
                                                        womanName[j].backgroundColor = Color("Turquesa")
                                                        break
                                                    } else {
                                                        womanName[j].backgroundColor = Color.white
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .onEnded { drag in
                                        withAnimation(.default) {
                                            var isCloseToAnyName: Bool = false
                                            for j in 0..<womanName.count {
                                                if !womanName[j].isCovered {
                                                    if womanPicture[i].squaredDistanceTo(womanName: womanName[j]) < 2500{
                                                        womanPicture[i].position = womanName[j].position
                                                        womanName[j].backgroundColor = Color.white
                                                        isCloseToAnyName = true
                                                        womanName[j].isCovered = true
                                                        womanPicture[i].coveringWomanName = womanName[j].name
                                                        break
                                                    }
                                                }
                                            }
                                            if !isCloseToAnyName {
                                                womanPicture[i].position = womanPicture[i].startPosition
                                            }
                                            activateSubmit = womanPicture.allSatisfy({$0.coveringWomanName != nil})
                                        }
                                    }
                            )
                    }
                }
            }
            Button(action: {
                
            }) {
                Text("Submit")
                    .fontWeight(.bold)
            }
            .importantButtonStyle()
            .disabled(!activateSubmit)
        }
    }
}

struct PairThemUpView_Previews: PreviewProvider {
    @State static var wp: [WomanPicture] = [
        WomanPicture(pictureName: "MarieCurie1", x:100, y:100),
        WomanPicture(pictureName: "MaeJemison1", x:100, y:300)
    ]
    static var wn: [WomanName] = [
        WomanName(name: "Marie Curie", position: CGPoint(x: 300, y: 300)),
        WomanName(name: "Mae Jemison", position: CGPoint(x: 300, y: 500)),
    ]
    
    static var previews: some View {
        PairThemUpView(womanPicture: wp, womanName: wn)
    }
}
