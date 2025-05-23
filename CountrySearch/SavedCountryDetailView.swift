//
//  SavedCountryDetailView.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/22/25.
//

import SwiftUI
import SwiftData

struct SavedCountryDetailView: View {
    var country : SavedCountry
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack {
                
                FlagImageView(imageData: country.flagImage, width: 300, height: 200)
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Country: ").bold() + Text(country.name)
                    Text("Region: ").bold() + Text(country.region)
                    Text("Subregion: ").bold() + Text(country.subregion ?? "N/A")
                    Text("Capital: ").bold() + Text(country.capital?.joined(separator: ", ") ?? "N/A")
                    Text("Currency: ").bold() + Text(country.currencies ?? "N/A")
                }
                .font(.title2)
                .padding(.top)
                
                Button("Delete") {
                    context.delete(country)
                    try? context.save()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            if country.coordinates != nil {
                MapView2(country: country)
            } else {
                Text("Map data not available")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    SavedCountryDetailView(country:
                            SavedCountry(
                                id: "asdf",
                                name: "USA",
                                capital: ["Washington D.C."],
                                region: "Americas",
                                subregion: "North America",
                                currencies: "USD $ Dollars",
                                flagURL: "something",
                                coordinates: [-4.4, 5.2])
    )
}
