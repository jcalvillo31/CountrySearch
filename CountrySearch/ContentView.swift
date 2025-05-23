//
//  ContentView.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/22/25.
//

import SwiftUI

struct ContentView: View {
    
    var service = DataService()
    @State var countries = [Country]()
    @State var language = ""
    @State var error: String?
    @State private var sortAscending = false
    
    var body: some View {
        
        NavigationStack{
            VStack {
                HStack {
                    TextField("Search by language (e.g. spanish)", text: $language)
                        .textFieldStyle(.roundedBorder)
                    Button("Search") {
                        Task {
                            do {
                                error = nil
                                let results = try await service.search(language: language)
                                countries = results.sorted(by: { a, b in
                                    a.id < b.id
                                })
                            } catch {
                                self.error = error.localizedDescription
                                countries.removeAll()
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Toggle("Sort Descending", isOn: $sortAscending)
                    .onChange(of: sortAscending) { _, _ in
                        countries.reverse()
                    }
                
                
                if let errorMessage = error {
                    Text(errorMessage).foregroundStyle(.red)
                }
                
                List(countries) { country in
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
}
#Preview {
    ContentView()
}


