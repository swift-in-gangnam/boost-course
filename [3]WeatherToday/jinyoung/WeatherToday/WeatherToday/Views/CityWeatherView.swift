//
//  CityWeatherView.swift
//  WeatherToday
//
//  Created by Jinyoung Kim on 2021/09/10.
//

import UIKit
import SnapKit

class CityWeatherView: UIView {
    
    let wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let stateNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    let rainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        wrapperView.addSubview(weatherImageView)
        wrapperView.addSubview(stateNameLabel)
        wrapperView.addSubview(tempLabel)
        wrapperView.addSubview(rainLabel)

        addSubview(wrapperView)

        weatherImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.width.equalTo(200)
            make.centerX.equalToSuperview()
        }

        let labelHeight: CGFloat = 20

        stateNameLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
            make.top.equalTo(weatherImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }

        tempLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
            make.top.equalTo(stateNameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }

        rainLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
            make.top.equalTo(tempLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }

        wrapperView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
