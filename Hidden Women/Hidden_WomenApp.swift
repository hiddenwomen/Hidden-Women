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
    var profile: Profile = Profile()
    init() {
        print("Init app")
        if let location = Bundle.main.url(forResource: "women", withExtension: "json") {
            do {
                let data = try Data(contentsOf: location)
                do{
                    women = try JSONDecoder().decode([Woman].self, from: data).sorted(by: {$0.name < $1.name})
                } catch {
                    print("Error in JSON: \(error)")
                }
            } catch {
                print("Error in JSON: \(error)")
            }
        }
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(profile)
        }
    }
}
