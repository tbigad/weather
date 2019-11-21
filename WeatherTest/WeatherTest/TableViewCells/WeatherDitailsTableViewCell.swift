//
//  WeatherDitailsTableViewCell.swift
//  WeatherTest
//
//  Created by Pavel N on 11/21/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import UIKit

class WeatherDitailsTableViewCell: BaseTableViewCell {
    static let reuseIdentifier:String = "WeatherDitailsTableViewCell"
    @IBOutlet var ditaledWeatherText: UILabel!
    override func cellPreffiredSize() -> CGFloat {
        return 150;
    }
}
