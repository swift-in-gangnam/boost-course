//
//  CityWeatherViewController.swift
//  WeatherToday
//
//  Created by Jinyoung Kim on 2021/09/04.
//

import UIKit

class CityWeatherViewController: UIViewController {
    
    private let customView = CityWeatherView()
    private let cityViewModel: CityViewModel
    
    // MARK: - Initializers
    init(cityViewModel: CityViewModel) {
        self.cityViewModel = cityViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.weatherImageView.image = UIImage(named: cityViewModel.stateImageName)
        customView.stateNameLabel.text = cityViewModel.stateStringKorean
        customView.tempLabel.text = cityViewModel.tempString
        customView.rainLabel.text = cityViewModel.rainfallProbString

        self.view.backgroundColor = .white
        self.view.addSubview(customView)
        
        customView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
