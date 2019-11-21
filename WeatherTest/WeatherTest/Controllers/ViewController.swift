//
//  ViewController.swift
//  WeatherTest
//
//  Created by Pavel N on 11/20/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let locationHelper = LocationHelper()
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    private var commonQueue:OperationQueue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationHelper.delegate = self
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "WeekWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: WeekWeatherTableViewCell.reuseIdentifier)
        tableView.register(UINib.init(nibName: "DailyDitailsTableViewCell", bundle: nil), forCellReuseIdentifier: DailyDitailsTableViewCell.reuseIdentifier)
        tableView.register(UINib.init(nibName: "WeatherDitailsTableViewCell", bundle: nil), forCellReuseIdentifier: WeatherDitailsTableViewCell.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HourlyCollectionViewCell.reuseIdentifier)
    }

    func updateBackendData(_ lat:Double, _ lon:Double) {
        commonQueue = OperationQueue()
        let operation = GetWeatherAsyncOperation(lon: lon, lat: lat)
        commonQueue?.addOperation(operation)
    }
}

extension ViewController:LocationHelperDelegate{
    func locationupdated(latitude: Double, longitude: Double) {
        updateBackendData(latitude, longitude)
    }
}

extension ViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else {
            return 48
        }
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeekWeatherTableViewCell.reuseIdentifier, for: indexPath)
            // Configure the cell
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDitailsTableViewCell.reuseIdentifier, for: indexPath)
            // Configure the cell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyDitailsTableViewCell.reuseIdentifier, for: indexPath)
            // Configure the cell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()//tableHeaderVC.view
    }
    
}

extension ViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.reuseIdentifier, for: indexPath)
        // Configure the cell
        return cell
    }
    
    
}

extension ViewController:UICollectionViewDelegate {
    
}
