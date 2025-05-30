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
