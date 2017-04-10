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
