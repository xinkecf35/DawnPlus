//
//  AddressViewController.swift
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-04-09.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddressViewController: UIViewController {
    //Properties
    var latitude:Double = 0
    var longitude:Double = 0
    var addressSearchController:UISearchController? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad();
        //LocationFetch location set and add observer
        latitude = LocationFetch.sharedInstance().latitude
        longitude = LocationFetch.sharedInstance().longitude
        LocationFetch.sharedInstance().addObserver(self, forKeyPath: #keyPath(LocationFetch.currentLocation), options: .new, context: nil)
        debugPrint("\(self) current location is: \(latitude), \(longitude)")
        //Setting MapView
        let span = MKCoordinateSpan(latitudeDelta: 0.05,longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: LocationFetch.sharedInstance().currentLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        //Setting Search Bar and Results table view
        let addressSearchTable = storyboard!.instantiateViewController(withIdentifier: "AddressSearchTable") as! AddressSearchTable
        addressSearchController = UISearchController(searchResultsController: addressSearchTable)
        addressSearchController?.searchResultsUpdater = addressSearchTable
        let searchBar = addressSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for your Work"
        navigationItem.titleView = addressSearchController?.searchBar
        addressSearchController?.hidesNavigationBarDuringPresentation = false
        addressSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        addressSearchTable.mapView = mapView
    }
    deinit {
        LocationFetch.sharedInstance().removeObserver(self, forKeyPath: #keyPath(LocationFetch.currentLocation))
    }
   
    //Key-Value Observe for LocationFetch(myLocation)
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(LocationFetch.currentLocation) {
            latitude = LocationFetch.sharedInstance().latitude
            longitude = LocationFetch.sharedInstance().longitude
            debugPrint("\(self) updated current location is: \(latitude), \(longitude)")
            
        }
    }
}
