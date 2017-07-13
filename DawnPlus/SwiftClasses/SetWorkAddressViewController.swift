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

class SetWorkAddressViewController:UIViewController {
    let defaults:UserDefaults = UserDefaults.standard
    let resultsController = AddressResultsViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LocationFetch.addObserver(self, forKeyPath: #keyPath(LocationFetch.currentLocation), options: NSKeyValueObservingOptions.new, context: nil)
    }
    override func viewDidLoad() {
        let mapView = MKMapView()
        let span = MKCoordinateSpanMake(0.02, 0.02)
    }
    
    func configureMapView() {
        
    }
    func configureSearchView() {
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
    }
}
