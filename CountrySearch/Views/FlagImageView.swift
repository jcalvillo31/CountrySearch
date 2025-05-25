//
//  FlagImageView.swift
//  CountrySearch
//
//  Created by Jose Manuel on 5/23/25.
//

import Foundation
import SwiftUI


// Convert image data to usable Image
struct FlagImageView: View {
    let imageData: Data?
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
        } else {
            Image(systemName: "flag")
                .resizable()
                .scaledToFit()
                .frame(height: height)
        }
    }
}
