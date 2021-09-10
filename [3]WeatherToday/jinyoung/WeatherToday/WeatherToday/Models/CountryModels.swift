//
//  CountryModels.swift
//  WeatherToday
//
//  Created by Jinyoung Kim on 2021/09/10.
//

import Foundation
import UIKit

struct CountryResponseDTO: Codable {
    
    let koreanName: String
    let assetName: String
    
    enum CodingKeys: String, CodingKey {
        case koreanName = "korean_name"
        case assetName = "asset_name"
    }
}

struct CountryListModel {
    
    let countries: [CountryResponseDTO]
    
    init(dataAssetName: String) {
        let jsonDecoder = JSONDecoder()
        guard let dataAsset = NSDataAsset(name: dataAssetName) else {
            self.countries = []
            print("⚠️ fetch dataAsset failed")
            return
        }
        
        do {
            self.countries = try jsonDecoder.decode([CountryResponseDTO].self, from: dataAsset.data)
        } catch {
            self.countries = []
            print("⚠️ decode dataAsset failed with error: \(error.localizedDescription)")
        }
    }
}

struct CountryModel {
    
    let country: CountryResponseDTO
}
