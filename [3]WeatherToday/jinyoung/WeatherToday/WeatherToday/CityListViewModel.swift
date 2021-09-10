//
//  CityListViewModel.swift
//  WeatherToday
//
//  Created by Jinyoung Kim on 2021/09/10.
//

import Foundation

/// ViewController가 가지고있게 될 ViewModel
class CityListViewModel {
    
    let cityListModel: CityListModel
    
    var numberOfCity: Int {
        return cityListModel.cities.count
    }
    
    func cityAtIndex(_ index: Int) -> CityViewModel {
        let cityModel = CityModel(city: cityListModel.cities[index])
        let cityViewModel = CityViewModel(model: cityModel)
        return cityViewModel
    }
    
    init(countryAssetName: String) {
        self.cityListModel = CityListModel(countryAssetName: countryAssetName)
    }
}

/// Cell 하나하나를 configure 할 때 사용되는 ViewModel
class CityViewModel {
    
    let cityModel: CityModel
    
    init(model: CityModel) {
        self.cityModel = model
    }
    
    // MARK: - Computing Properties For Convenience
    var cityName: String {
        return cityModel.city.cityName
    }
    
    var celsius: Double {
        return cityModel.city.celsius
    }
    
    var fahrenheit: Double {
        return self.celsius * 1.8 + 32
    }
    
    var fahrenheitString: String {
        return String(format: "%.2f", self.fahrenheit)
    }
    
    var tempString: String {
        return "섭씨 \(self.celsius)도 / 화씨 \(self.fahrenheitString)도"
    }
    
    var rainfallProbability: Int {
        return cityModel.city.rainfallProbability
    }
    
    var rainfallProbString: String {
        return "강수확률 \(self.rainfallProbability)%"
    }
    
    var state: Int {
        return cityModel.city.state
    }
    
    var stateImageName: String {
        switch self.state {
        case 10:
            return "sunny"
        case 11:
            return "cloudy"
        case 12:
            return "rainy"
        case 13:
            return "snowy"
        default:
            return "sunny"
        }
    }
    
    var stateStringKorean: String {
        switch self.state {
        case 10:
            return "맑음"
        case 11:
            return "구름"
        case 12:
            return "비"
        case 13:
            return "눈"
        default:
            return "맑음"
        }
    }
}
