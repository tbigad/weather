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
    @IBOutlet var currentTemperuteLabel: UILabel!
    @IBOutlet var currentWeatherStateLabel: UILabel!
    @IBOutlet var currentCityLabel: UILabel!
    private var commonQueue:OperationQueue?
    private var weatherData:WeatherData = WeatherData()
    
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
        operation.completionBlock = {
            [weak operation , weak self] in
            guard let op = operation else {
                return
            }
            switch op.result {
            case .succes:
                guard let curr = op.currentResult, let hour = op.hourlyResult else {
                    return
                }
                self?.weatherData.parseBackendData(curr, hour)
                DispatchQueue.main.async {
                    self?.updateHeaderInfo()
                    self?.tableView.reloadData()
                }
            case .failed(let errorString):
                self?.showAlertMessage(title: "error", message: errorString, handle: {})
            case .none:
                break
            }
        }
        commonQueue?.addOperation(operation)
    }
    func updateHeaderInfo() {
        if (weatherData.currentWeather == nil) {
            return
        }
        currentCityLabel.text = weatherData.currentWeather?.cityName
        currentTemperuteLabel.text = "\(weatherData.currentWeather?.temperature ?? 256)"
        currentWeatherStateLabel.text = weatherData.currentWeather?.clouds
        collectionView.reloadData()
    }
}

extension ViewController:LocationHelperDelegate{
    func locationupdated(latitude: Double, longitude: Double) {
        updateBackendData(latitude, longitude)
    }
}

extension ViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.cellForRow(at: indexPath) as? BaseTableViewCell else {
            return 48
        }
        return cell.cellPreffiredSize()
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.ditails.count + 2
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
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyDitailsTableViewCell.reuseIdentifier, for: indexPath) as! DailyDitailsTableViewCell
            cell.bindData(weatherData.ditails[indexPath.row - 2])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()//tableHeaderVC.view
    }
    
}

extension ViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherData.events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.reuseIdentifier, for: indexPath) as! HourlyCollectionViewCell
        cell.bindData(weatherData.events[indexPath.row])
        return cell
    }
    
    
}

extension ViewController:UICollectionViewDelegate {
    
}
