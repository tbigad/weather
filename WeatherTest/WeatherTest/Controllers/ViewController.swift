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
    
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
