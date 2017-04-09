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
    
    override func viewDidLoad() {
        super.viewDidLoad();
        latitude = LocationFetch.sharedInstance().latitude
        longitude = LocationFetch.sharedInstance().longitude
        LocationFetch.sharedInstance().addObserver(self, forKeyPath: #keyPath(LocationFetch.currentLocation), options: .new, context: nil)
        debugPrint("\(self) current location is: \(latitude), \(longitude)")
        
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
