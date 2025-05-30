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
                    ForEach(groupedByRegion) { group in
                        Section("Region: \(group.region)") {
                            ForEach(group.countries) { country in
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
       groupByRegion(countries)
    }
    
}

#Preview {
    SavedList()
}
