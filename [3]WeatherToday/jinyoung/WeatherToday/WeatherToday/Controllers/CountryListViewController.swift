//
//  CountryListViewController.swift
//  WeatherToday
//
//  Created by Jinyoung Kim on 2021/09/04.
//

import UIKit
import SnapKit

class CountryListViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView()
    private let countryListViewModel = CountryListViewModel(dataAssetName: "countries")
    private let reuseIdentifier = "cell"
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // addSubview and autolayout
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension CountryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryListViewModel.numberOfCountry
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let countryViewModel = countryListViewModel.countryAtIndex(indexPath.row)
        cell.imageView?.image = UIImage(named: countryViewModel.imageName)
        cell.textLabel?.text = countryViewModel.koreanName
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CountryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryViewModel = countryListViewModel.countryAtIndex(indexPath.row)
        
        let vc = CityListViewController(countryAssetName: countryViewModel.assetName)
        vc.navigationItem.title = countryViewModel.koreanName
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

