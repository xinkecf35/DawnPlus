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

    var coordinate: CLLocationCoordinate2D!
    
    //UIKit Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewDidLoad() {
        LocationFetch.addObserver(self, forKeyPath: #keyPath(LocationFetch.currentLocation), options: NSKeyValueObservingOptions.new, context: nil)
        coordinate = LocationFetch.sharedInstance().currentLocation.coordinate
        definesPresentationContext = true;
        configureSearchView()
        configureMapView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    //Configure Views
    func configureMapView() {
//        let navigationBarHeight = self.navigationController!.navigationBar.frame.height;
        let mapViewHeight = view.frame.height;
        let mapFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: mapViewHeight )
        let mapView = MKMapView(frame: mapFrame)
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated: true)
        view.insertSubview(mapView, at: 0)
//        mapView.snp.makeConstraints({ (make) -> Void in
//            //Bounds
//            let searchBarHeight = searchController.searchBar.frame.size.height
//
//            //Make constraints
//            make.top.equalTo(view).offset(searchBarHeight)
//            make.bottom.equalTo(view)
//        })
        debugPrint("Map View Added")
        
    }
    func configureSearchView() {
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
//        searchController.delegate = self;
        searchController.hidesNavigationBarDuringPresentation = false;
        resultsController.searchController = searchController
        //Searchbar setting
        searchController.searchBar.delegate = resultsController
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Search for your Workplace"
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        //Setting Frame and Adding View
        let navigationBarHeight = self.navigationController!.navigationBar.frame.height;
        let searchBarFrame = CGRect(x: 0, y: navigationBarHeight + 22, width: view.frame.width, height: 44)
        searchBar.frame = searchBarFrame
        searchBar.sizeToFit()
        view.addSubview(searchBar)
        debugPrint("Added Search Bar View")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == #keyPath(LocationFetch.currentLocation)) {
            
        }
    }
}
extension SetWorkAddressViewController:UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
    }
   
}
