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
        if let location = Bundle.main.url(forResource: "women", withExtension: "json") {
            do {
                let data = try Data(contentsOf: location)
                let locale = Locale(identifier: language)
                do{
                    women = try JSONDecoder()
                        .decode([Woman].self, from: data)
                        .sorted(by: {$0.name.compare($1.name, locale: locale) == .orderedAscending})
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
