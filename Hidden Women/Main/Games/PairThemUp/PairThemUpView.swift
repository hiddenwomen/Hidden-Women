//
//  PairThemUpView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 4/4/21.
//

import SwiftUI

struct PairThemUpMistake: Identifiable {
    let picture: String
    let correctAnswer: String
    let incorrectAnswer: String
    let pairThemUpNumber: Int
    let id = UUID()
}

struct WomanPicture {
    let picture: String
    var startPosition: CGPoint
    var position: CGPoint = CGPoint(x: 0, y: 0)
    var zIndex: Double = 1
    var coveringWomanName: String? = nil
    var correctName: String
    
    init(pictureName: String, x: CGFloat, y: CGFloat, womanName: String) {
        self.picture = pictureName
        self.startPosition = CGPoint(x: x, y: y)
        self.position = CGPoint(x: x, y: y)
        self.correctName = womanName
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

struct PairThemUpGame {
    var womanNames: [WomanName]
    var womanPictures: [WomanPicture]
}

func pairThemUpGenerator(numberOfWomen: Int, women: [Woman], xName: CGFloat, xPicture: CGFloat, firstY: CGFloat, lastY: CGFloat) -> PairThemUpGame {
    let women = women.filter{$0.pictures[0] != "imagen1"}.shuffled()[0..<min(numberOfWomen, women.count)]
    let names = women.map{$0.name.localized}.shuffled()
    let pictures = women.map{($0.name.localized, $0.pictures.randomElement() ?? "")}
    var womanNames: [WomanName] = []
    var womanPictures: [WomanPicture] = []
    let incY = (lastY - firstY) / CGFloat(women.count)
    for i in 0..<names.count {
        womanNames.append(WomanName(name: names[i], position: CGPoint(x: xName, y: firstY + CGFloat(i) * incY)))
        womanPictures.append(WomanPicture(pictureName: pictures[i].1, x: xPicture, y: firstY + CGFloat(i) * incY, womanName: pictures[i].0))
    }
    return PairThemUpGame(womanNames: womanNames, womanPictures: womanPictures)
}

struct PairThemUpView: View {
    @Binding var pairThemUpGame: PairThemUpGame
    @State var activateSubmit: Bool = false
    @Binding var shownPairThemUp: Int
    @Binding var progress: CGFloat
    @Binding var timeLeft: Int
    @Binding var showTimer: Bool
    @Binding var mistakes: [[PairThemUpMistake]]
    @Binding var correctAnswers: Int
    let numberOfPairThemUp: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let numberOfWomen: Int = 5
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                    ForEach(0..<pairThemUpGame.womanNames.count) { i in
                        Circle()
                            .strokeBorder(Color("Morado"), lineWidth: 3)
                            .background(Circle().foregroundColor(pairThemUpGame.womanNames[i].backgroundColor))
                            .frame(width: min(geo.size.width / 4, 120) + 10)
                            .position(pairThemUpGame.womanNames[i].position)
                        Text(pairThemUpGame.womanNames[i].name)
                            .bold()
                            .foregroundColor(Color("Morado"))
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: geo.size.width / 4 - 10)
                            .position(x: pairThemUpGame.womanNames[i].position.x - geo.size.width / 4 - 10, y: pairThemUpGame.womanNames[i].position.y)
                    }
                    ForEach(0..<pairThemUpGame.womanPictures.count) { i in
                        Image(pairThemUpGame.womanPictures[i].picture)
                            .resizable()
                            .scaledToFit()
                            .frame(width: min(geo.size.width / 4, 120))
                            .clipShape(Circle())
                            .position(x: pairThemUpGame.womanPictures[i].position.x, y: pairThemUpGame.womanPictures[i].position.y)
                            .zIndex(pairThemUpGame.womanPictures[i].zIndex)
                            .gesture(
                                DragGesture()
                                    .onChanged { drag in
                                        activateSubmit = false
                                        withAnimation(.default) {
                                            pairThemUpGame.womanPictures[i].zIndex = pairThemUpGame.womanPictures.map{$0.zIndex}.max()! + 0.0001
                                            if let name = pairThemUpGame.womanPictures[i].coveringWomanName {
                                                for j in 0..<pairThemUpGame.womanNames.count {
                                                    if pairThemUpGame.womanNames[j].name == name {
                                                        pairThemUpGame.womanNames[j].isCovered = false
                                                        break
                                                    }
                                                }
                                            }
                                            pairThemUpGame.womanPictures[i].coveringWomanName = nil
                                            pairThemUpGame.womanPictures[i].position = drag.location
                                            for j in 0..<pairThemUpGame.womanNames.count {
                                                if !pairThemUpGame.womanNames[j].isCovered {
                                                    if pairThemUpGame.womanPictures[i].squaredDistanceTo(womanName: pairThemUpGame.womanNames[j]) < 2500{
                                                        pairThemUpGame.womanNames[j].backgroundColor = Color("Turquesa")
                                                        break
                                                    } else {
                                                        pairThemUpGame.womanNames[j].backgroundColor = Color.white
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .onEnded { drag in
                                        withAnimation(.default) {
                                            var isCloseToAnyName: Bool = false
                                            for j in 0..<pairThemUpGame.womanNames.count {
                                                if !pairThemUpGame.womanNames[j].isCovered {
                                                    if pairThemUpGame.womanPictures[i].squaredDistanceTo(womanName: pairThemUpGame.womanNames[j]) < 2500{
                                                        pairThemUpGame.womanPictures[i].position = pairThemUpGame.womanNames[j].position
                                                        pairThemUpGame.womanNames[j].backgroundColor = Color.white
                                                        isCloseToAnyName = true
                                                        pairThemUpGame.womanNames[j].isCovered = true
                                                        pairThemUpGame.womanPictures[i].coveringWomanName = pairThemUpGame.womanNames[j].name
                                                        break
                                                    }
                                                }
                                            }
                                            if !isCloseToAnyName {
                                                pairThemUpGame.womanPictures[i].position = pairThemUpGame.womanPictures[i].startPosition
                                            }
                                            activateSubmit = pairThemUpGame.womanPictures.allSatisfy({$0.coveringWomanName != nil})
                                        }
                                    }
                            )
                    }
                }
            }
            if activateSubmit{
                Button(action: {
                    mistakes.append(checkResults())
                    progress += 1.0 / CGFloat(numberOfPairThemUp)
                    shownPairThemUp += 1
                    if shownPairThemUp < numberOfPairThemUp {
                        pairThemUpGame = pairThemUpGenerator(
                            numberOfWomen: numberOfWomen,
                            women: women,
                            xName: UIScreen.width - 70,
                            xPicture: 70, firstY: 70,
                            lastY: UIScreen.height - 200
                        )
                        timeLeft = pairThemUpConfig.availableTime
                    }
                    showTimer = false
                    activateSubmit = false
                    print("\(correctAnswers) \(mistakes)")
                }) {
                    Text("Submit")
                        .fontWeight(.bold)
                        .importantButtonStyle()
                }
            }
        }
        .onReceive(timer) { _ in
            timeLeft -= 1
            if timeLeft < 0 {
                mistakes.append(checkResults())
                timer.upstream.connect().cancel()
                progress += 1.0 / CGFloat(numberOfPairThemUp)
                showTimer = false
                shownPairThemUp += 1
                timeLeft = pairThemUpConfig.availableTime
                if shownPairThemUp < numberOfPairThemUp {
                    pairThemUpGame = pairThemUpGenerator(
                        numberOfWomen: numberOfWomen,
                        women: women,
                        xName: UIScreen.width - 70,
                        xPicture: 70, firstY: 70,
                        lastY: UIScreen.height - 200
                    )
                    timeLeft = pairThemUpConfig.availableTime
                }
                showTimer = false
            }
        }
    }
    
    func checkResults() -> [PairThemUpMistake] {
        var buffer: [PairThemUpMistake] = []
        for picture in pairThemUpGame.womanPictures {
            if picture.coveringWomanName == picture.correctName {
                correctAnswers += 1
            } else {
                correctAnswers -= 1
                buffer.append(PairThemUpMistake(
                                    picture: picture.picture,
                                    correctAnswer: picture.correctName,
                                    incorrectAnswer: picture.coveringWomanName ?? "You ran out of time",
                                    pairThemUpNumber: shownPairThemUp
                ))
            }
        }
        return buffer
    }
}

//struct PairThemUpView_Previews: PreviewProvider {
//    @State static var pairThemUp: PairThemUpGame = //pairThemUpGenerator(numberOfWomen: 5, women: women, xName: //UIScreen.width - 70, xPicture: 70, firstY: 70, lastY: //UIScreen.height - 200)
//
//
//    static var previews: some View {
//        PairThemUpView(pairThemUpGame: pairThemUp)
//    }
//}
