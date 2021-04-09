//
//  Message.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 8/4/21.
//

import Foundation
import Firebase

class Chat: ObservableObject {
    let aId: String
    let bId: String
    @Published var lastAccess: [String: Int]
    @Published var messages: [ChatMessage]
    var key: String {
        return "\(aId)::\(bId)"
    }
    
    init(aId: String, bId: String) {
        if aId < bId {
            self.aId = aId
            self.bId = bId
        } else {
            self.aId = bId
            self.bId = aId
        }
        self.lastAccess = [aId: 0, bId: 0]
        self.messages = []
    }
    
    func toDict() -> [String: Any] {
        return [
            aId: 0,
            bId: 0,
            "messages": messages.map{$0.toDict()},
            "participants": [aId, bId]
        ]
    }
    
    func load(onError: @escaping (Error) -> Void) {
        Firestore.firestore()
            .collection("chats")
            .document(self.key)
            .getDocument { documentSnapshot, error in
                if let error = error {
                    onError(error)
                } else if let documentSnapshot = documentSnapshot {
                    self.load(document: documentSnapshot)
                }
            }
    }
    
    func load(document: DocumentSnapshot) {
        let data: [String: Any] = document.data() ?? [:]
        
        let docLastAccess = [
            aId: data[aId] as? Int ?? 0,
            bId: data[bId] as? Int ?? 0
        ]
        
        let dataMessages = data["messages"] as? [[String: String]] ?? []
        var docMessages: [ChatMessage] = []
        for message in dataMessages {
            docMessages.append(ChatMessage.from(dict: message))
        }
        
        lastAccess = docLastAccess
        messages = docMessages
    }
    
    
    func setLastAcces(toId: String, onError: @escaping (Error) -> Void) {
        let now: Int = Int(Date().timeIntervalSince1970)
        let data: [String: Int] = [ toId: now ]
        Firestore.firestore()
            .collection("chats")
            .document(self.key)
            .updateData(data) { error in
                if let error = error {
                    onError(error)
                }
            }
    }
    
    func listen(onChange: @escaping () -> Void) -> ListenerRegistration {
        print("!!! Fijo un escuchador para chat \(self.key)")
        return Firestore.firestore()
            .collection("chats")
            .document(key)
            .addSnapshotListener { document, error in
                if let error = error {
                    print("Error fetching document: \(error)")
                    return
                } else if let document = document {
                    print("ESCUCHANDO CHATS")
                    // chat.load(document: document)
                    self.load(document: document)
                    onChange()
                }
            }
    }
    
    
    func send(message: ChatMessage, onError: @escaping (Error) -> Void) {
        print("!!! Añado mensaje a chat \(key)")
        
        messages.append(message)
        
        let reference = Firestore.firestore()
            .collection("chats")
            .document(self.key)
        
        reference.getDocument() { documentSnapshot, error in
            if let error = error {
                onError(error)
            } else if let documentSnapshot = documentSnapshot {
                if documentSnapshot.exists {
                    print("!!! Ya existía el chat y añado el mensaje")
                    reference
                        .updateData([
                            "messages": FieldValue.arrayUnion([message.toDict()])
                        ]) { error in
                            if let error = error {
                                onError(error)
                            }
                        }
                } else {
                    print("!!! No existía el chat, así que lo creo")
                    reference.setData(self.toDict())
                }
            }
        }
    }
}

