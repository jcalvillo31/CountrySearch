//
//  DataService.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/22/25.
//

import Foundation

protocol ServiceProtocol {
    func search(language: String) async throws -> [Country]
}

struct DataService: ServiceProtocol {
    // Endpoint: https://restcountries.com/v3.1/lang/{language}
    
    func search(language: String) async throws -> [Country] {
        
        guard let url = URL(string: "https://restcountries.com/v3.1/lang/\(language)") else {
            print("Invalid URL")
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // 4. Parse JSON
            let decoder = JSONDecoder()
            let result = try decoder.decode([Country].self, from: data)
            
            return result
            
        }
        catch {
            print("Error decoding json: \(error.localizedDescription)")
            throw error
        }
        
    }
    
}
