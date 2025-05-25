//
//  SavedCountries.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/22/25.
//

import SwiftUI
import SwiftData

struct SavedList: View {
    @Query(sort: \SavedCountry.name) private var countries: [SavedCountry]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        
        NavigationStack {
            if !countries.isEmpty {
                List{
                    ForEach(groupedByRegion) { regionGroup in
                        Section("Region: \(regionGroup.region)") {
                            ForEach(regionGroup.countries) { country in
                                NavigationLink(destination: SavedCountryDetailView(country: country)) {
                                    HStack {
                                        FlagImageView(imageData: country.flagImage, width: 40, height: 40)
                                        Text(country.name)
                                    }
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        context.delete(country)
                                        try? context.save()
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                Text("""
                     List is empty
                     Add some countries to your list!
                     """)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            }
        }
        .navigationTitle("Saved countries")
    }
    
    var groupedByRegion: [CountryRegion] {
        /// Group all the countries in SwiftData by region in dictionary format
        /// region becomes the key
        Dictionary(grouping: countries, by: { $0.region })
        /// Call map on the Dictionary to convert back to array
            .map { key, value in
                CountryRegion(region: key, countries: value.sorted {$0.name < $1.name })
            }
            .sorted { a, b in
                a.region < b.region
            }
    }
    
}

struct CountryRegion: Identifiable {
    let region: String
    let countries: [SavedCountry]
    var id = UUID()
}

#Preview {
    SavedList()
}
