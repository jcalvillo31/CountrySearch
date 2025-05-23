//
//  DetailView.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/22/25.
//

import Foundation
import SwiftUI
import SwiftData

struct DetailView: View {
    var country: Country
    @Environment(\.modelContext) private var modelContext
    @State var confirmSave = ""
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                AsyncImage(url: URL(string: country.flags?.png ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 200)
                        .background(Color.gray.opacity(0.2).blur(radius: 5))
                    
                    
                    
                } placeholder: {
                    Image(systemName: "flag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 200)
                        .padding(.bottom, 40)
                    
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Country: ").bold() + Text(country.name.common)
                    Text("Region: ").bold() + Text(country.region)
                    Text("Subregion: ").bold() + Text(country.subregion ?? "N/A")
                    Text("Capital: ").bold() + Text(country.capital?.joined(separator: ", ") ?? "No capital")
                    Text("Currency: ").bold() + Text(currency)
                }
                .font(.title2)
                
                Button("Save Country") {
                    Task {
                        await saveCountry(from: country, context: modelContext)
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Text(confirmSave)
                    .foregroundStyle(.red)
                    .padding(.top)
                    .font(.title2)
            }
            .padding()
            
            if country.capitalInfo != nil {
                MapView(country: country)
            } else {
                Text("Map data not available")
                    .foregroundStyle(.secondary)
            }
                
        }
    }
    var currency: String {
        country.currencies?
            .map { "\($0.key) \($0.value.symbol) \($0.value.name)" }
            .joined(separator: ", ") ?? "N/A"
    }
    
    func saveCountry(from country: Country, context: ModelContext) async {
        let newCountry = SavedCountry(from: country)
        
        if let urlString = newCountry.flagURL,
           let url = URL(string: urlString) {
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                /// assign flag data to Swift Data model
                newCountry.flagImage = data
                
            } catch {
                print("Failed downloading image: \(error)")
            }
        } else {
            print("Missing or invalid flag URL")
        }
        
        /// Swift Data runs on main thread so use main actor wrapper
        await MainActor.run {
            context.insert(newCountry)
            try? context.save() // This will prevent duplicates
            confirmSave = "Saved!"
            print("Country and flag image saved!")
        }
    }
}

#Preview("with map data") {
    DetailView(country: Country(
        name: Country.Name(common: "USA", official: "The USA"),
        currencies: ["USD": Country.Currency(name: "Dollars", symbol: "$")],
        capital: ["Washington, D.C."],
        region: "North America",
        subregion: "Northern America",
        flags: Country.Flag(png: "https://flagcdn.com/w320/us.png"),
        capitalInfo: Country.Coordinates(latlng: [38.8977, -77.0365])
    ))
}

#Preview("no map data") {
    DetailView(country: Country(
        name: Country.Name(common: "USA", official: "The USA"),
        currencies: ["USD": Country.Currency(name: "Dollars", symbol: "$")],
        capital: ["Washington, D.C."],
        region: "North America",
        subregion: "Northern America",
        flags: Country.Flag(png: "https://flagcdn.com/w320/us.png"),
        capitalInfo: nil)
    )
}
