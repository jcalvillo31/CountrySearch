//
//  ViewModel.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/30/25.
//

import Foundation
import Observation

@Observable
class ViewModel {
    
    var countries = [Country]()
    var service: ServiceProtocol
    var error: String?
    
    init(service: ServiceProtocol = DataService()) {
        self.service = service
    }
    
    func handleSearch(language: String) async {
        do {
            // reset error message upon new search
            error = nil
            
            let query = language
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            countries = try await service.search(language: query)
            
        } catch {
            self.error = error.localizedDescription
            // reset list after each search
            countries.removeAll()
        }
    }
}
