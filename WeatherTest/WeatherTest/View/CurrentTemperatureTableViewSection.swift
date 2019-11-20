//
//  CurrentTemperatureTableViewSection.swift
//  WeatherTest
//
//  Created by Pavel N on 11/20/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import UIKit

class CurrentTemperatureTableViewSection: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:  "CurrentTemperatureTableViewSection", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }

}
