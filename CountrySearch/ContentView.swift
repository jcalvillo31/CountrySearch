//
//  ContentView.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/22/25.
//

import SwiftUI

struct ContentView: View {
    
    private var service = DataService()
    @State private var countries = [Country]()
    @State private var language = ""
    @State private var error: String?
    @State private var sortOrder = false
    
    var body: some View {
        
        NavigationStack{
            VStack {
                HStack {
                    
                    TextField("Search by language (e.g. spanish)", text: $language)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Search") {
                        handleSearch()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Toggle("Sort Descending", isOn: $sortOrder)
                
                if let errorMessage = error {
                    Text(errorMessage).foregroundStyle(.red)
                }
                
                List(sortedCountries) { country in
                    NavigationLink(destination: DetailView(country: country)) {
                        HStack {
                            AsyncImage(url: URL(string: country.flags?.png ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            } placeholder: {
                                Image(systemName: "flag.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.gray)
                            }
                            
                            Text(country.name.common)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Countries")
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SavedCountries()
                    } label: {
                        Text("Saved")
                    }
                }
            }
        }
    }
    
    private var sortedCountries: [Country] {
        countries.sorted { a, b in
            // valueIfTrue : valueIfFalse
            sortOrder ? a.id > b.id : a.id < b.id
        }
    }
    
    private func handleSearch() {
        Task {
            do {
                error = nil // reset error message upon new search
                
                let language = language
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .lowercased()
                countries = try await service.search(language: language)
                
            } catch {
                self.error = error.localizedDescription
                // reset list after each search
                countries.removeAll()
            }
        }
    }
}
#Preview {
    ContentView()
}


