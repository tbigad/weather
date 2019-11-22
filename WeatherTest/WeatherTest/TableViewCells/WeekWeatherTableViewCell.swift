//
//  WeekWeatherTableViewCell.swift
//  WeatherTest
//
//  Created by Pavel N on 11/21/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import UIKit

class WeekWeatherTableViewCell: BaseTableViewCell {
    
    static let reuseIdentifier = "WeekWeatherTableViewCell"
    private var dataByDays:DaysOverview = []
    @IBOutlet var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
        let width = (self.frame.width-20)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 50)
        collectionView.register(UINib.init(nibName: "NextWeekWeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: NextWeekWeatherCollectionViewCell.reuseIdentifier)
        
    }
    func bindData(_ data:DaysOverview){
        dataByDays = data
        collectionView.reloadData()
    }
    override func cellPreffiredSize() -> CGFloat {
        return 300
    }
}

extension WeekWeatherTableViewCell: UICollectionViewDelegate {
    
}

extension WeekWeatherTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataByDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NextWeekWeatherCollectionViewCell.reuseIdentifier, for: indexPath) as! NextWeekWeatherCollectionViewCell
        cell.bindData(dataByDays[indexPath.row])
        // Configure the cell
        return cell
    }
}
