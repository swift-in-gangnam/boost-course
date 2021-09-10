//
//  CityTableViewCell.swift
//  WeatherToday
//
//  Created by Jinyoung Kim on 2021/09/10.
//

import UIKit
import SnapKit

class CityTableViewCell: UITableViewCell {

    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let rightView = UIView()
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    let rainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(weatherImageView)
        addSubview(rightView)
        rightView.addSubview(cityNameLabel)
        rightView.addSubview(tempLabel)
        rightView.addSubview(rainLabel)
        
        weatherImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.height.equalTo(weatherImageView.snp.width)
        }
        
        rightView.snp.makeConstraints { make in
            make.leading.equalTo(weatherImageView.snp.trailing)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let labelSpacing: CGFloat = 5
        let labelHeight: CGFloat = 20
        
        cityNameLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(labelSpacing)
            make.trailing.equalToSuperview().inset(labelSpacing)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(labelSpacing)
            make.leading.equalToSuperview().inset(labelSpacing)
            make.trailing.equalToSuperview().inset(labelSpacing)
        }
        
        rainLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
            make.top.equalTo(tempLabel.snp.bottom).offset(labelSpacing)
            make.leading.trailing.bottom.equalToSuperview().inset(labelSpacing)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
