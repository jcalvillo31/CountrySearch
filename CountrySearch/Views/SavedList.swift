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
    @State private var searchText: String = ""
    @State private var selection = 0
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Picker("View Mode", selection: $selection) {
                    Text("By Region").tag(0)
                    Text("By Name").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if selection == 0 {
                    
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
                        EmptyList()
                    }
                }
                
                else if selection == 1 {
                    
                    if !countries.isEmpty {
                        List(filteredCountries) { country in
                            Text(country.name)
                        }
                    } else {
                        EmptyList()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search for a country")
        }
        .navigationTitle("Saved countries")
        
    }
    
    var groupedByRegion: [CountryRegion] {
        groupByRegion(filteredCountries)
    }
    
    var filteredCountries: [SavedCountry] {
        guard !searchText.isEmpty else { return countries }
        
        return countries.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
}

#Preview {
    SavedList()
}

struct EmptyList: View {
    var body: some View {
        
        VStack {
            Spacer()
            Text("""
             List is empty
             Add some countries to your list!
             """)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            Spacer()
            
        }
    }
    
}
