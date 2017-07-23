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
    var mapView: MKMapView?
    let reuseIdentifier = "addressCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingPlaces.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let selectedAddress = matchingPlaces[indexPath.row].placemark
        cell.textLabel?.text = selectedAddress.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedAddress)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = matchingPlaces[indexPath.row].placemark
        mapSearchDelegate?.dropMapPin(placemark: selectedCell)
        dismiss(animated: true, completion: nil)
    }
    //Address handling
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
    func updateSearchResults(searchPhrase: String?) {
        guard let requestRegion = mapView?.region, let input = searchPhrase  else {
            return
        }
        let request = MKLocalSearchRequest()
        request.region = requestRegion
        request.naturalLanguageQuery = input
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, _) in
            guard let response = response else {
                return
            }
            self.matchingPlaces = response.mapItems
            self.tableView.reloadData()
        })
    }
}
protocol addressMapSearch {
    func dropMapPin(placemark: MKPlacemark)
}

