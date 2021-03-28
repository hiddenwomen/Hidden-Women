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
    @AppStorage("userID") var userID: String = ""
    var profile: Profile = Profile()
    //var listener: ListenerRegistration
    
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
                .onAppear {
                    if userID != "" {
                        loadProfile(userID: userID, profile: profile, andFriends: true)
                        let listener = Firestore.firestore()
                            .collection("users")
                            .document(userID)
                            .addSnapshotListener { documentSnapshot, error in
                                guard let document = documentSnapshot else {
                                    print("Error fetching document: \(error!)")
                                    return
                                }
                                loadProfile(userID: userID, profile: profile, andFriends: true)
                            }
                    }
                    print("\(Int(Date().timeIntervalSince1970))")
                }
        }
    }
}
