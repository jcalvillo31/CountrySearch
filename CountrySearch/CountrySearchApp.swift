//
//  CountrySearchApp.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/22/25.
//

import SwiftUI
import SwiftData

@main
struct CountrySearchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: SavedCountry.self)
        }
    }
}
