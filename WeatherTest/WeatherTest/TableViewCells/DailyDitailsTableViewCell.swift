//
//  DailyDitailsTableViewCell.swift
//  WeatherTest
//
//  Created by Pavel N on 11/21/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import UIKit

class DailyDitailsTableViewCell: BaseTableViewCell {
    static let reuseIdentifier:String = "DailyDitailsTableViewCell"
    @IBOutlet var variableNameLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func cellPreffiredSize() -> CGFloat {
        return 60
    }
    
    func bindData(_ data: WeatherDitail){
        variableNameLabel.text = data.name
        valueLabel.text = "\(data.value) \(data.postfix)"
    }
}
