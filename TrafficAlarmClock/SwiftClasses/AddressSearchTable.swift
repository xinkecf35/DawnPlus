//
//  AddressSearchTable.swift
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-04-09.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//


import UIKit
import MapKit

class AddressSearchTable: UITableViewController {
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        var addressLine:String = "";
        var addressComponents:[String] = [];
        addressComponents.append(selectedItem.subThoroughfare ?? "")
        addressComponents.append(selectedItem.thoroughfare ?? "")
        addressComponents.append(selectedItem.locality ?? "")
        addressComponents.append(selectedItem.administrativeArea ?? "")
        addressComponents.append(selectedItem.postalCode ?? "")
        addressLine = addressComponents.joined(separator: " ")
    
        return addressLine
    }
    
}
extension AddressSearchTable: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, _) in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        })
    }
}
extension AddressSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
}
extension AddressSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropMapPin(placemark: selectedCell)
        dismiss(animated: true, completion: nil)
    }
}
