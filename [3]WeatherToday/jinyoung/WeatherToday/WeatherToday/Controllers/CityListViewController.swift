//
//  CityListViewController.swift
//  WeatherToday
//
//  Created by Jinyoung Kim on 2021/09/04.
//

import UIKit

class CityListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let cityListViewModel: CityListViewModel
    private let reuseIdentifier = "cell"
    
    // MARK: - Initializers
    init(countryAssetName: String) {
        self.cityListViewModel = CityListViewModel(countryAssetName: countryAssetName)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Private funcs
    private func setupTableView() {
        // set dataSource and delegate for tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // register cell for reuse
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // addSubview and autolayout
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension CityListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityListViewModel.numberOfCity
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CityTableViewCell else { fatalError() }
        let cityViewModel = cityListViewModel.cityAtIndex(indexPath.row)
        cell.weatherImageView.image = UIImage(named: cityViewModel.stateImageName)
        cell.cityNameLabel.text = cityViewModel.cityName
        cell.tempLabel.text = cityViewModel.tempString
        cell.rainLabel.text = cityViewModel.rainfallProbString
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CityListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityViewModel = cityListViewModel.cityAtIndex(indexPath.row)
        
        let vc = CityWeatherViewController(cityViewModel: cityViewModel)
        vc.navigationItem.title = cityViewModel.cityName
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
