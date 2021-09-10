//
//  CountryList.swift
//  WeatherToday
//
//  Created by Jinyoung Kim on 2021/09/10.
//

import Foundation
import UIKit

struct CountryResponseModel: Codable {
    
    let koreanName: String
    let assetName: String
    
    enum CodingKeys: String, CodingKey {
        case koreanName = "korean_name"
        case assetName = "asset_name"
    }
}

struct CountryList {
    
    var countries: [CountryResponseModel]
    
    init() {
        let jsonDecoder = JSONDecoder()
        guard let dataAsset = NSDataAsset(name: "countries") else {
            self.countries = []
            print("⚠️ fetch dataAsset failed")
            return
        }
        
        do {
            self.countries = try jsonDecoder.decode([CountryResponseModel].self, from: dataAsset.data)
        } catch {
            self.countries = []
            print("⚠️ decode dataAsset failed with error: \(error.localizedDescription)")
        }
    }
}
