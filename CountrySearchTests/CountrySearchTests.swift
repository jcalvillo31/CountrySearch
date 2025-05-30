//
//  CountrySearchTests.swift
//  CountrySearchTests
//
//  Created by Jose Manuel on 5/29/25.
//

import Testing
import Foundation

@testable import CountrySearch

private final class BundleLocater {} // used to locate bundle

struct CountryTests {
    
    @Test(arguments: ["complete", "extra"])
    func testDecoding(fileName: String) throws {
        
        guard let url = Bundle(for: BundleLocater.self)
            .url(forResource: fileName, withExtension: "json") else {
            fatalError("Mock file not found")
        }
        
        let jsonData = try Data(contentsOf: url)
        
        let result = try JSONDecoder().decode([Country].self, from: jsonData)
        
        #expect(!result.isEmpty)
        #expect(result[0].id == "USA")
    }
    
    @Test func decodingSeveralCountries() throws {
        guard let url = Bundle(for: BundleLocater.self)
            .url(forResource: "many", withExtension: "json") else {
            fatalError("Mock file not found")
        }
        
        let jsonData = try Data(contentsOf: url)
        
        let result = try JSONDecoder().decode([Country].self, from: jsonData)
        
        #expect(result[1].id == "Japan")
    }
    
    @Test func sortDescending() {
        let countries = [
            Country(
                name: Country.Name(common: "ABC", official: "ABC"),
                region: "North America"),
            Country(
                name: Country.Name(common: "DEF", official: "DEF"),
                region: "South America")
        ]
        
        let result = sortCountries(countries, descending: false)
        
        #expect(result[0].id == "ABC" )
    }
}
