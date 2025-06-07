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
        ZStack {
            Color(.gray)
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                
                Group {
                    AsyncImage(url: URL(string: country.flags?.png ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 200)
                        
                    } placeholder: {
                        Image(systemName: "flag")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                        
                    }
                }
                .padding(.bottom, 40)
                .padding(.top, 10)
                
                VStack(alignment: .center, spacing: 10) {
                    Text("Country: ").bold() + Text(country.name.common)
                    Text("Region: ").bold() + Text(country.region)
                    Text("Subregion: ").bold() + Text(country.subregion ?? "N/A")
                    Text("Capital: ").bold() + Text(country.capital?.joined(separator: ", ") ?? "No capital")
                    VStack() {
                        Text("Currency:").bold()
                        ForEach(currencyList, id: \.self) { c in
                            Text("• \(c)")
                        }
                    }
                    
                    Button("Save Country") {
                        Task {
                            await saveCountry(from: country, context: modelContext)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                    
                    Text(confirmSave)
                        .foregroundStyle(.red)
                        .font(.title2)
                }
                
                if country.capitalInfo?.latlng != nil {
                    MapView(country: country)
                } else {
                    Text("Map data not available")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    var currencyList: [String] {
        /// convert dictionary to array of type String
        /// example ["USD $ Dollars", "MXN $ Pesos"]
        country.currencies?
            .map { "\($0.key): \($0.value.symbol) \($0.value.name)" } ?? ["N/A"]
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
        currencies: ["USD": Country.Currency(name: "Dollars", symbol: "$"),
                     "MXN": Country.Currency(name: "Pesos", symbol: "$"),
                     "LEN": Country.Currency(name: "Pesos", symbol: "$")],
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
