//
//  Country.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/22/25.
//

import Foundation
import SwiftData

/// For decoding json data
///
struct Country: Decodable, Identifiable {
    var id: String {name.common}
    
    var name: Name
    var currencies: [String: Currency]? // It is a dicitonary
    var capital: [String]?
    var region: String
    var subregion: String?
    var flags: Flag?
    var capitalInfo: Coordinates?
    
    struct Coordinates: Decodable {
        var latlng: [Double]? // sometimes nil
    }
    
    struct Name: Decodable {
        var common: String
        var official: String
    }

    struct Currency: Decodable {
        var name: String
        var symbol: String
    }

    struct Flag: Decodable {
        var png: String
    }
}


/// Swift Data model
///
@Model
class SavedCountry {
    var id: String
    @Attribute(.unique)var name: String  // .unique prevents duplicates
    var capital: [String]?
    var region: String
    var subregion: String?
    var currencies: [String]?
    var flagURL: String?
    @Attribute(.externalStorage) var flagImage: Data?
    var coordinates: [Double]?
    
    init(id: String, name: String, capital: [String]? = nil, region: String, subregion: String? = nil,
         currencies: [String]? = nil, flagURL: String? = nil, flagImage: Data? = nil, coordinates: [Double]? = nil)
    {
        self.id = id
        self.name = name
        self.capital = capital
        self.region = region
        self.subregion = subregion
        self.currencies = currencies
        self.flagURL = flagURL
        self.flagImage = flagImage
        self.coordinates = coordinates
    }
    /// Creates a SavedCountry from a decoded Country object
    convenience init(from country: Country) {
        self.init(
            id: country.id,
            name: country.name.common,
            capital: country.capital,
            region: country.region,
            subregion: country.subregion,
            currencies: country.currencies?.map {
                "\($0.key) \($0.value.symbol) \($0.value.name)" },
            flagURL: country.flags?.png,
            flagImage: nil,
            coordinates: country.capitalInfo?.latlng
        )
    }
}

/// Example of currency dictionary in the JSON
// let currencies: [String: Currency] = [
// "USD": Currency(symbol: "$", name: "United States Dollar"),
// "EUR": Currency(symbol: "€", name: "Euro")
// ]
