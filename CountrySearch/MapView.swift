//
//  MapView.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/22/25.
//

import SwiftUI
import MapKit


struct MapView: View {
    
    @State var cameraPosition: MapCameraPosition = .automatic
    var country: Country
    
    var location: CLLocationCoordinate2D {
        let latlng = country.capitalInfo?.latlng
        /// can force unwrap since we only show map if it not nil
        return CLLocationCoordinate2D(latitude: latlng![0], longitude: latlng![1])
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            // capital is an array so use the .first
            if let capital = country.capital?.first {
                Marker(capital, coordinate: location)
            }
        }
        .frame(height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
        .onAppear {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                )
            )
            
        }
    }
}

#Preview("Country") {
    MapView(country: Country(
        name: Country.Name(common: "USA", official: "The USA"),
        currencies: ["USD": Country.Currency(name: "Dollars", symbol: "$")],
        capital: ["Washington, D.C."],
        region: "North America",
        subregion: "Northern America",
        flags: Country.Flag(png: "https://flagcdn.com/w320/us.png"),
        capitalInfo: Country.Coordinates(latlng: [38.8977, -77.0365])
    ))
}


// For the SavedCountry model
struct MapView2: View {
    
    @State var cameraPosition: MapCameraPosition = .automatic
    var country: SavedCountry
    
    var location: CLLocationCoordinate2D {
        let latlng = country.coordinates
        return CLLocationCoordinate2D(latitude: latlng![0], longitude: latlng![1])
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            // capital is an array so use the .first
            if let capital = country.capital?.first {
                Marker(capital, coordinate: location)
            }
        }
        .frame(height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
        .onAppear {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                )
            )
            
        }
    }
}

#Preview("Saved Country") {
    MapView2(country: SavedCountry(
        id: "USA",
        name: "United States",
        capital: ["Columbus, OH"],
        region: "North America",
        coordinates: [38.8, -77.0] )
    )
}
