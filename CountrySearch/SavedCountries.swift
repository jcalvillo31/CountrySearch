//
//  SavedCountries.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/22/25.
//

import SwiftUI
import SwiftData

struct SavedCountries: View {
    @Query(sort: \SavedCountry.name) private var countries: [SavedCountry]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        
        NavigationStack {
            if !countries.isEmpty {
                List(countries) { c in
                    
                    NavigationLink(destination: SavedCountryDetailView(country: c)) {
                        
                        HStack {
                            FlagImageView(imageData: c.flagImage, width: 40, height: 40)
                            Text(c.name)
                        }
                        .swipeActions {
                            Button("Delete", systemImage: "trash") {
                                modelContext.delete(c)
                            }.tint(.red)
                        }
                    }
                }
            } else {
                Text("""
                     List is empty -
                     Add some countries to your list!
                     """)
                .font(.title)
                .multilineTextAlignment(.center)
            }
        }
        .navigationTitle("Saved countries")
    }
}


#Preview {
    SavedCountries()
}
