//
//  SetAddressViewController.swift
//  DawnPlus
//
//  Created by Xinke Chen on 2017-06-19.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SetAddressViewController: UIViewController,UISearchBarDelegate{
    
    let defaults:UserDefaults = UserDefaults.standard;
    var searchController: UISearchController!
    var latitude:Double = 0
    var longitude:Double = 0
    var selectedAddress:MKPlacemark? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapSearchBar: UISearchBar!;
    
    override func viewDidLoad() {
        latitude = LocationFetch.sharedInstance().latitude
        longitude = LocationFetch.sharedInstance().longitude
        LocationFetch.sharedInstance().addObserver(self, forKeyPath: #keyPath(LocationFetch.currentLocation), options: NSKeyValueObservingOptions.new, context: nil)
        configureMapview()
        configureSearchController()
    }
    func configureSearchController() {
        let addressResultsController = storyboard!.instantiateViewController(withIdentifier: "AddressResults")
        searchController = UISearchController(searchResultsController: addressResultsController)
        mapSearchBar = searchController.searchBar;
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        
    }
    func configureMapview() {
        let span = MKCoordinateSpan(latitudeDelta: 0.05,longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: LocationFetch.sharedInstance().currentLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    deinit {
        LocationFetch.sharedInstance().removeObserver(self, forKeyPath: #keyPath(LocationFetch.currentLocation))
    }
}
extension SetAddressViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

