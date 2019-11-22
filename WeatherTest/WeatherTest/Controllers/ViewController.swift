//
//  ViewController.swift
//  WeatherTest
//
//  Created by Pavel N on 11/20/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let locationHelper = LocationHelper()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var currentTemperuteLabel: UILabel!
    @IBOutlet var currentWeatherStateLabel: UILabel!
    @IBOutlet var currentCityLabel: UILabel!
    
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var titleTopConstraint: NSLayoutConstraint!
    
    private var commonQueue:OperationQueue?
    private var weatherData:WeatherData = WeatherData()
    private let maxHeaderHeight: CGFloat = 250
    private let minHeaderHeight: CGFloat = 100
    private var previousScrollOffset: CGFloat = 0
    private var previousScrollViewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationHelper.delegate = self
        // Do any additional setup after loading the view.
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "WeekWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: WeekWeatherTableViewCell.reuseIdentifier)
        tableView.register(UINib.init(nibName: "DailyDitailsTableViewCell", bundle: nil), forCellReuseIdentifier: DailyDitailsTableViewCell.reuseIdentifier)
        tableView.register(UINib.init(nibName: "WeatherDitailsTableViewCell", bundle: nil), forCellReuseIdentifier: WeatherDitailsTableViewCell.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HourlyCollectionViewCell.reuseIdentifier)
        
        self.previousScrollViewHeight = self.tableView.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerHeightConstraint.constant = self.maxHeaderHeight
        self.updateHeader()
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
        if indexPath.row == 0 {
            return 300
        } else {
            return UITableView.automaticDimension;
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        defer {
            self.previousScrollViewHeight = scrollView.contentSize.height
            self.previousScrollOffset = scrollView.contentOffset.y
        }

        let heightDiff = scrollView.contentSize.height - self.previousScrollViewHeight
        let scrollDiff = (scrollView.contentOffset.y - self.previousScrollOffset)

        guard heightDiff == 0 else { return }

        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;

        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom

        if canAnimateHeader(scrollView) {
            var newHeight = self.headerHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }

            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(self.previousScrollOffset)
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }

    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)

        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }

    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight

        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }

    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }

    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }

    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }

    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range

        //self.titleTopConstraint.constant = -openAmount + 10
        self.currentTemperuteLabel.alpha = percentage
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.ditails.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeekWeatherTableViewCell.reuseIdentifier, for: indexPath) as! WeekWeatherTableViewCell
            cell.bindData(weatherData.daysOverview)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDitailsTableViewCell.reuseIdentifier, for: indexPath)
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
