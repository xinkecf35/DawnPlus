//
//  AddressResultsViewController.swift
//  DawnPlus
//
//  Created by Hackintosh on 7/2/17.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddressResultsViewController:UITableViewController {
    var matchingPlaces: [MKMapItem] = []
    var mapSearchDelegate: addressMapSearch? = nil
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        var addressLine: String = ""
        var addressComponents: [String] = []
        addressComponents.append(selectedItem.subThoroughfare ?? "")
        addressComponents.append(selectedItem.thoroughfare ?? "")
        addressComponents.append(selectedItem.locality ?? "")
        addressComponents.append(selectedItem.administrativeArea ?? "")
        addressComponents.append(selectedItem.postalCode ?? "")
        addressLine = addressComponents.joined(separator: " ")
        return addressLine
    }
    func updateSearchResults() {
        
    }

}
protocol addressMapSearch {
    func dropMapPin(placemark: MKPlacemark)
}

