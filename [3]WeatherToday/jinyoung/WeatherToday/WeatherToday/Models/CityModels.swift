//
//  CityModels.swift
//  WeatherToday
//
//  Created by Jinyoung Kim on 2021/09/10.
//

import Foundation
import UIKit

struct CityResponseDTO: Codable {
    
    let cityName: String
    let state: Int
    let celsius: Double
    let rainfallProbability: Int
    
    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case state, celsius
        case rainfallProbability = "rainfall_probability"
    }
}

struct CityListModel {
    
    let cities: [CityResponseDTO]
    
    init(countryAssetName: String) {
        let jsonDecoder = JSONDecoder()
        guard let dataAsset = NSDataAsset(name: countryAssetName) else {
            self.cities = []
            print("⚠️ fetch dataAsset failed")
            return
        }
        
        do {
            self.cities = try jsonDecoder.decode([CityResponseDTO].self, from: dataAsset.data)
        } catch {
            self.cities = []
            print("⚠️ decode dataAsset failed with error: \(error.localizedDescription)")
        }
    }
}

struct CityModel {
    
    let city: CityResponseDTO
}
