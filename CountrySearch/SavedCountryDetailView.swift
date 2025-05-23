//
//  SavedCountryDetailView.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/22/25.
//

import SwiftUI
import SwiftData

struct SavedCountryDetailView: View {
    var country: SavedCountry
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
    
            FlagImageView(imageData: country.flagImage, width: 300, height: 200)
                .padding(.bottom, 40)
                .padding(.top, 10)
                
            VStack(spacing: 10) {
                Text("Country: ").bold() + Text(country.name)
                Text("Region: ").bold() + Text(country.region)
                Text("Subregion: ").bold() + Text(country.subregion ?? "N/A")
                Text("Capital: ")
                    .bold() + Text(
                        country.capital?.joined(separator: ", ") ?? "N/A"
                    )
                    
                VStack {
                    Text("Currency:").bold()
                    ForEach(country.currencies ?? ["N/A"], id: \.self) { c in
                        Text("• \(c)")
                    }
                }
            }
            .padding(.top)
                
            Button("Delete") {
                context.delete(country)
                try? context.save()
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
            
            if country.coordinates != nil {
                MapView2(country: country)
            } else {
                Text("Map data not available")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview("With values") {
    SavedCountryDetailView(country:
                            SavedCountry(
                                id: "asdf",
                                name: "USA",
                                capital: ["Washington D.C."],
                                region: "Americas",
                                subregion: "North America",
                                currencies: ["USD $ Dollars, MXN $ Pesos"],
                                flagURL: "something",
                                coordinates: [-4.4, 5.2])
    )
}

#Preview("Nil values") {
    SavedCountryDetailView(country:
                            SavedCountry(
                                id: "asdf",
                                name: "USA",
                                capital: nil,
                                region: "Americas",
                                subregion: nil,
                                currencies: nil,
                                flagURL: nil,
                                coordinates: nil)
    )
}
