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
var mainListener: ListenerRegistration? = nil

class RankingUpdater: ObservableObject {
    @Published var counter: Int = 0
    
    func change() {
        counter += 1
    }
}

@main
struct Hidden_WomenApp: App {
    @AppStorage("userID") var userID: String = ""
    var profile: Profile = Profile()
    var rankingUpdater = RankingUpdater()
    
    init() {
        if let location = Bundle.main.url(forResource: "women", withExtension: "json") {
            do {
                let data = try Data(contentsOf: location)
                let locale = Locale(identifier: language)
                do{
                    women = try JSONDecoder()
                        .decode([Woman].self, from: data)
                        .sorted(by: {$0.name.localized.compare($1.name.localized, locale: locale) == .orderedAscending})
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
                .environmentObject(rankingUpdater)
                .onAppear {
                    print("EMPIEZA EL ESPECTACULO")
                    if userID != "" {
                        print("--- Carga del profile")
                        //loadProfile(userID: userID, profile: profile, andFriends: true)
                        mainListener = listenToAndUpdateProfile(userID: userID, profile: profile, rankingUpdater: rankingUpdater, andFriends: true)
                        print("Y escuchador conectado")
                    }
                }
        }
    }
}
