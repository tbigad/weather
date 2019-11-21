//
//  HourlyCollectionViewCell.swift
//  WeatherTest
//
//  Created by Pavel N on 11/21/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HourlyWeatherCell"
    @IBOutlet var time: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var temperature: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(_ event:HourlyEvent) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh a"
        let hourString = formatter.string(from: event.time)
        time.text = hourString
        temperature.text = String(event.temp)
        icon.image = UIImage(systemName: "cloud")
    }
}
