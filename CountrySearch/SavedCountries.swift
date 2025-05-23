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
            
        }
        .navigationTitle("Saved countries")
    }
    
}

// Convert image data to usable Image

struct FlagImageView: View {
    let imageData: Data?
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
        } else {
            Image(systemName: "flag")
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
        }
    }
}

#Preview {
    SavedCountries()
}
