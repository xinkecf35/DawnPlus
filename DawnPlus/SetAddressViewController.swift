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

class SetAddressViewController: UIViewController, UISearchBarDelegate{
    
    let defaults:UserDefaults = UserDefaults.standard;
    var searchController: UISearchController!
    var latitude:Double = 0
    var longitude:Double = 0
    var selectedAddress:MKPlacemark? = nil
    
    override func viewDidLoad() {
        latitude = LocationFetch.sharedInstance().latitude
        longitude = LocationFetch.sharedInstance().longitude
        LocationFetch.sharedInstance().addObserver(self, forKeyPath: #keyPath(LocationFetch.currentLocation), options: NSKeyValueObservingOptions.new, context: nil)
        configureMapview()
        configureSearchController()
    }
    func configureSearchController() {
        
    }
    func configureMapview() {
       
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == #keyPath(LocationFetch.currentLocation)) {
            latitude = LocationFetch.sharedInstance().latitude
            longitude = LocationFetch.sharedInstance().longitude
            debugPrint("\(self) updated current location is: \(latitude), \(longitude)")
        }
    }
    deinit {
        LocationFetch.sharedInstance().removeObserver(self, forKeyPath: #keyPath(LocationFetch.currentLocation))
    }
}

