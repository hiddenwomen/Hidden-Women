//
//  ChatView.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 5/4/21.
//

import SwiftUI

// --- from: https://prafullkumar77.medium.com/swiftui-creating-a-chat-bubble-like-imessage-using-path-and-shape-67cf23ccbf62
struct ChatBubble<Content>: View where Content: View {
    let direction: ChatBubbleShape.Direction
    let topInfo: String
    let content: () -> Content
    init(direction: ChatBubbleShape.Direction, topInfo: String, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.topInfo = topInfo
        self.direction = direction
    }
    
    var body: some View {
        HStack {
            if direction == .right {
                Spacer()
            }
            VStack(alignment: direction == .right ? .trailing : .leading) {
                Text(topInfo)
                    .font(.caption2)
                    .foregroundColor(.gray)
                content().clipShape(ChatBubbleShape(direction: direction))
            }
            if direction == .left {
                Spacer()
            }
        }
        .padding([(direction == .left) ? .leading : .trailing, .top, .bottom], 20)
        .padding((direction == .right) ? .leading : .trailing, 50)
    }
}

struct ChatBubbleShape: Shape {
    enum Direction {
        case left
        case right
    }
    
    let direction: Direction
    
    func path(in rect: CGRect) -> Path {
        return (direction == .left) ? getLeftBubblePath(in: rect) : getRightBubblePath(in: rect)
    }
    
    private func getLeftBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x: width - 20, y: height))
            p.addCurve(to: CGPoint(x: width, y: height - 20),
                       control1: CGPoint(x: width - 8, y: height),
                       control2: CGPoint(x: width, y: height - 8))
            p.addLine(to: CGPoint(x: width, y: 20))
            p.addCurve(to: CGPoint(x: width - 20, y: 0),
                       control1: CGPoint(x: width, y: 8),
                       control2: CGPoint(x: width - 8, y: 0))
            p.addLine(to: CGPoint(x: 21, y: 0))
            p.addCurve(to: CGPoint(x: 4, y: 20),
                       control1: CGPoint(x: 12, y: 0),
                       control2: CGPoint(x: 4, y: 8))
            p.addLine(to: CGPoint(x: 4, y: height - 11))
            p.addCurve(to: CGPoint(x: 0, y: height),
                       control1: CGPoint(x: 4, y: height - 1),
                       control2: CGPoint(x: 0, y: height))
            p.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
            p.addCurve(to: CGPoint(x: 11.0, y: height - 4.0),
                       control1: CGPoint(x: 4.0, y: height + 0.5),
                       control2: CGPoint(x: 8, y: height - 1))
            p.addCurve(to: CGPoint(x: 25, y: height),
                       control1: CGPoint(x: 16, y: height),
                       control2: CGPoint(x: 20, y: height))
            
        }
        return path
    }
    
    private func getRightBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x:  20, y: height))
            p.addCurve(to: CGPoint(x: 0, y: height - 20),
                       control1: CGPoint(x: 8, y: height),
                       control2: CGPoint(x: 0, y: height - 8))
            p.addLine(to: CGPoint(x: 0, y: 20))
            p.addCurve(to: CGPoint(x: 20, y: 0),
                       control1: CGPoint(x: 0, y: 8),
                       control2: CGPoint(x: 8, y: 0))
            p.addLine(to: CGPoint(x: width - 21, y: 0))
            p.addCurve(to: CGPoint(x: width - 4, y: 20),
                       control1: CGPoint(x: width - 12, y: 0),
                       control2: CGPoint(x: width - 4, y: 8))
            p.addLine(to: CGPoint(x: width - 4, y: height - 11))
            p.addCurve(to: CGPoint(x: width, y: height),
                       control1: CGPoint(x: width - 4, y: height - 1),
                       control2: CGPoint(x: width, y: height))
            p.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
            p.addCurve(to: CGPoint(x: width - 11, y: height - 4),
                       control1: CGPoint(x: width - 4, y: height + 0.5),
                       control2: CGPoint(x: width - 8, y: height - 1))
            p.addCurve(to: CGPoint(x: width - 25, y: height),
                       control1: CGPoint(x: width - 16, y: height),
                       control2: CGPoint(x: width - 20, y: height))
            
        }
        return path
    }
}

// ---

func configuredDateFormatter() -> DateFormatter {
    let df = DateFormatter()
    df.timeStyle = DateFormatter.Style.medium //Set time style
    df.dateStyle = DateFormatter.Style.medium //Set date style
    df.timeZone = .current
    return df
}

struct ChatView: View {
    @EnvironmentObject var profile: Profile
    @AppStorage ("userID") var userID: String = ""
    let friendId: String
    @State var currentMessage = ""
    let dateFormatter: DateFormatter = configuredDateFormatter()
    @State private var scrollTarget: Int = 0

    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollReader in
                    VStack {
                        ForEach(profile.chatWith(friendId: friendId)) { message in
                            VStack {
                                ChatBubble(
                                    direction: message.from == userID ? .right : .left,
                                    topInfo: dateFormatter.string(from: Date(timeIntervalSince1970: Double(message.time)))
                                ) {
                                    Text(message.text)
                                        .padding(.all, 20)
                                        .foregroundColor(message.from == userID ? Color.white : Color.black)
                                        .background(message.from == userID ? Color("Morado") : Color("Turquesa"))
                                }
                                .id(message.time)
                            }
                        }
                    }
                    .onChange(of: scrollTarget) { target in
                        withAnimation {
                            scrollReader.scrollTo(target, anchor: .bottomTrailing)
                        }
                    }
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if let message = profile.chatWith(friendId: friendId).first {
                        scrollTarget = message.time
                    }
                }) {
                    Image(systemName: "arrow.up")
                }
                Spacer()
                Button(action: {
                    if let message = profile.chatWith(friendId: friendId).last {
                        scrollTarget = message.time
                    }
                }) {
                    Image(systemName: "arrow.down")
                }
                Spacer()
            }
            HStack {
                TextField("Type here...", text: $currentMessage)
                    .frame(height: 60)
                    .padding(.horizontal, 20)
                    .background(Color("Hueso"))
                    .cornerRadius(16)
                    .padding(.leading, 10)
                Image(systemName: "paperplane.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(Color("Morado"))
                    .onTapGesture {
                        sendChatMessage(
                            message: Message(
                                from: userID,
                                to: friendId,
                                text: currentMessage,
                                time: Int(Date().timeIntervalSince1970),
                                read: false
                            ),
                            onError: {error in }) //TODO: Error
                    }
            }
        }
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
