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
        print("End init app")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
