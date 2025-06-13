//
//  ViewModelTest.swift
//  CountrySearchTests
//
//  Created by Jose Manuel on 5/30/25.
//

import Testing
@testable import CountrySearch

struct ViewModelTests {
    
    struct MockDataService: ServiceProtocol {
        enum DummyError: Error {
            case testFailure
        }
        
        let result: Result<[Country], DummyError>
        
        func search(language: String) async throws -> [Country] {
            try result.get()
        }
    }
    
    @Test func successfulSearch() async {
        let countries = [
            Country(
                name: Country.Name(common: "ABC", official: "ABC"),
                region: "North America"),
            Country(
                name: Country.Name(common: "DEF", official: "DEF"),
                region: "South America")
        ]
        
        let mockService = MockDataService(result: .success(countries))
        let vm = ViewModel(service: mockService)
        
        // This runs the mock "search" func above
        await vm.handleSearch(language: "english")
        
        #expect(vm.countries.count == 2)
        #expect(vm.error == nil)
    }
    
    @Test func failedSearch() async {
        
        let mockService = MockDataService(result: .failure(.testFailure))
        let vm = ViewModel(service: mockService)
        
        await vm.handleSearch(language: "french")
        
        #expect(vm.countries.isEmpty)
        #expect(vm.error != nil)
        
    }
}
