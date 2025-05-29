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
    
    @Test func testDecoding_withCompleteData() throws {
        // Arrange
        guard let url = Bundle(for: BundleLocater.self)
            .url(forResource: "complete", withExtension: "json") else {
            fatalError("Mock file not found")
        }
        
        let jsonData = try Data(contentsOf: url)
        
        // Act
        let decodedCountries = try JSONDecoder().decode([Country].self, from: jsonData)
        
        // Assert:
        #expect(!decodedCountries.isEmpty)
        #expect(decodedCountries[0].id == "USA")
        
    }
    
    @Test func testDecoding_withExtraData() throws {
        // Arrange
        guard let url = Bundle(for: BundleLocater.self)
            .url(forResource: "extra", withExtension: "json") else {
            fatalError("Mock file not found")
        }
        
        let jsonData = try Data(contentsOf: url)
        
        // Act
        let decodedCountries = try JSONDecoder().decode([Country].self, from: jsonData)
        
        // Assert
        #expect(!decodedCountries.isEmpty)
        #expect(decodedCountries[0].id == "USA")
    }
    
    @Test func testDecoding_withManyCountries() throws {
        // Arrange
        guard let url = Bundle(for: BundleLocater.self)
            .url(forResource: "many", withExtension: "json") else {
            fatalError("Mock file not found")
        }
        
        let jsonData = try Data(contentsOf: url)
        
        // Act
        let decodedCountries = try JSONDecoder().decode([Country].self, from: jsonData)
        
        // Assert
        #expect(decodedCountries.count == 2)
        #expect(decodedCountries[0].name.common == "USA")
        #expect(decodedCountries[1].name.common == "Japan")
    }
}
