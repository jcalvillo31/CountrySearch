//
//  ContentView.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/22/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var viewModel = ViewModel()
    @State private var language = ""
    @State private var isSortDescending = false
    
    var body: some View {
        
        NavigationStack{
            VStack {
                HStack {
                    
                    TextField("Search by language (e.g. spanish)", text: $language)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Search") {
                        Task {
                            await viewModel.handleSearch(language: language)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Toggle("Sort Descending", isOn: $isSortDescending)
                
                if let errorMessage = viewModel.error {
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
                        SavedList()
                    } label: {
                        Text("Saved")
                        Image(systemName: "chevron.right")
                            .fontWeight(.medium)
                            .padding(.leading, -5)
                    }
                }
            }
        }
    }
    
    private var sortedCountries: [Country] {
        sortCountries(viewModel.countries, descending: isSortDescending)
    }
    
}
#Preview {
    ContentView()
}


