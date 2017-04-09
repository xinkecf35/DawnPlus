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
    //LocationFetch Singleton
    let myLocation:AnyObject = LocationFetch.sharedInstance()
    var latitude:Double = 0
    var longitude:Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        latitude = myLocation.latitude
        longitude = myLocation.longitude
        debugPrint("\(self) current location is: \(latitude), \(longitude)")
        
    }
    //Key-Value Observe for LocationFetch(myLocation)
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        }
    
}
