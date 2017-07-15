//
//  SetWorkAddressViewController.swift
//  DawnPlus
//
//  Created by Xinke Chen on 2017-07-01.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SnapKit

class SetWorkAddressViewController:UIViewController {
    let defaults:UserDefaults = UserDefaults.standard
    let resultsController = AddressResultsViewController()
    var searchController:UISearchController! = nil
    var coordinate: CLLocationCoordinate2D!
    
    //UIKit Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LocationFetch.addObserver(self, forKeyPath: #keyPath(LocationFetch.currentLocation), options: NSKeyValueObservingOptions.new, context: nil)
    }
    override func viewDidLoad() {
        coordinate = LocationFetch.sharedInstance().currentLocation.coordinate
        configureSearchView()
//        configureMapView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    //Configure Views
    func configureMapView() {
        let mapView = MKMapView()
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated: true)
        view.addSubview(mapView)
        mapView.snp.makeConstraints({ (make) -> Void in
            //Bounds
            let searchBarHeight = searchController.searchBar.frame.size.height
            
            //Make constraints
            make.top.equalTo(view).offset(searchBarHeight)
            make.bottom.equalTo(view)
        })
        debugPrint("Map View Added")
        
    }
    func configureSearchView() {
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        let searchBar = searchController.searchBar
        view.addSubview(searchBar)
        searchBar.placeholder = "Search for your Workplace"
        //Setting Frame
//        debugPrint(self.navigationController?.navigationBar.frame.height as Any)
        let navigationBarHeight = self.navigationController!.navigationBar.frame.height;
        let searchBarFrame = CGRect(x: 0, y: navigationBarHeight + 22, width: view.frame.width, height: 44)
        searchBar.frame = searchBarFrame
        debugPrint("Added Search Bar View")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == #keyPath(LocationFetch.currentLocation)) {
            
        }
    }
}
