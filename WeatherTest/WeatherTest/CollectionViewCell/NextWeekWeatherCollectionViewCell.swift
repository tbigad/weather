//
//  NextWeekWeatherCollectionViewCell.swift
//  WeatherTest
//
//  Created by Pavel N on 11/21/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import UIKit

class NextWeekWeatherCollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier:String = "NextWeekWeatherCollectionViewCell"
    
    @IBOutlet var nameOfDayLabel: UILabel!
    @IBOutlet var dayMaxTempLabel: UILabel!
    @IBOutlet var dayMinTempLabel: UILabel!
    @IBOutlet var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(_ data: DayOverview) {
        nameOfDayLabel.text = data.nameOfDay
        dayMaxTempLabel.text = String(data.maxTemp)
        dayMinTempLabel.text = String(data.minTemp)
        image.image = UIImage(named: data.iconName)
    }

}
