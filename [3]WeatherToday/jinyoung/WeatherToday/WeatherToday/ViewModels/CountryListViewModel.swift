//
//  CountryListViewModel.swift
//  WeatherToday
//
//  Created by Jinyoung Kim on 2021/09/10.
//

import Foundation

/// ViewController가 가지고있게 될 ViewModel
class CountryListViewModel {
    
    let countryListModel: CountryListModel
    
    init(dataAssetName: String) {
        self.countryListModel = CountryListModel(dataAssetName: dataAssetName)
    }
    
    var numberOfCountry: Int {
        return countryListModel.countries.count
    }
    
    func countryAtIndex(_ index: Int) -> CountryViewModel {
        let countryModel = CountryModel(country: countryListModel.countries[index])
        let countryViewModel = CountryViewModel(model: countryModel)
        return countryViewModel
    }
}

/// Cell 하나하나를 configure 할 때 사용되는 ViewModel
class CountryViewModel {
    
    let countryModel: CountryModel
    
    init(model: CountryModel) {
        self.countryModel = model
    }
    
    // MARK: - Computing Properties For Convenience
    var koreanName: String {
        return countryModel.country.koreanName
    }
    
    var assetName: String {
        return countryModel.country.assetName
    }
    
    var imageName: String {
        return "flag_" + self.assetName
    }
}
