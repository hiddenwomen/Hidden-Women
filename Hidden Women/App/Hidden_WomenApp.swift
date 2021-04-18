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

class RankingUpdater: ObservableObject {
    @Published var counter: Int = 0
    
    func change() {
        counter += 1
    }
}

@main
struct Hidden_WomenApp: App {
    @AppStorage("userID") var userID: String = ""
    var profile: Profile = Profile(userId: "")
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
                    if userID != "" {
                        print("--- Carga del profile")
                        profile.userId = userID
                        profile.load(rankingUpdater: rankingUpdater) {
                            profile.friendProfiles = profile.friendProfiles.sorted(by: { $0.name < $1.name })
                        }
                        profile.listen(rankingUpdater: rankingUpdater) {
                            profile.friendProfiles = profile.friendProfiles.sorted(by: { $0.name < $1.name })
                        }
                        print("Y escuchador conectado")
                    }
                }
        }
    }
}
