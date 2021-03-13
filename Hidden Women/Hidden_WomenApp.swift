//
//  Hidden_WomenApp.swift
//  Hidden Women
//
//  Created by Claudia Marzal Polop on 9/3/21.
//

import SwiftUI
import Firebase

var language = Locale.current.languageCode ?? "en"
var women: [Woman] = []

@main
struct Hidden_WomenApp: App {
    
    init() {
        print("Init app")
        if let location = Bundle.main.url(forResource: "women", withExtension: "json") {
            do {
                let data = try Data(contentsOf: location)
                do{
                    women = try JSONDecoder().decode([Woman].self, from: data)
                } catch {
                    print("Error en el JSON: \(error)")
                }
            } catch {
                print("Error en la lectura del JSON: \(error)")
            }
        }
        FirebaseApp.configure()
        Auth.auth().signIn(withEmail: "tirame@alabasura.com", password: "basura") { user, error in
            if let error = error {
                print("ERROR!!! \(error.localizedDescription)")
            } else {
                let userID = user?.user.uid ?? ""
                print("SOY \(userID)")
                Firestore.firestore().collection("users").document("fFM6mMkDLPSBJYOCarId0ofW0pA3").getDocument { d, e in
                    print("D:> \(String(describing: d))")
                    print("E:> \(String(describing: e))")
                }
            }
        }

//        Firestore.firestore().collection("xxx").document("a").getDocument { d, e in
//            print("D:> \(String(describing: d))")
//            print("E:> \(String(describing: e))")
//        }
        print("End init app")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
