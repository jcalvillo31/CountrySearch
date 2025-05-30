//
//  functions.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/29/25.
//

import Foundation

func sortCountries(_ countries: [Country], descending: Bool) -> [Country] {
    countries.sorted { a, b in
        descending ? a.id > b.id : a.id < b.id
    }
}

func groupByRegion(_ countries: [SavedCountry]) -> [CountryRegion] {
    let grouped = Dictionary(grouping: countries) { $0.region }
    
    let array = grouped.map { key, values in
        CountryRegion(region: key, countries: values.sorted(by: { $0.name < $1.name }))
    }
    
    return array.sorted { $0.region < $1.region }
    
}

struct CountryRegion: Identifiable {
    let region: String
    let countries: [SavedCountry]
    var id = UUID()
}

