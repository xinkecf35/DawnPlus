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
    let searchBar = UISearchBar()
    let mapView = MKMapView()
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
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    //Configure Views
    func configureMapView() {
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        let navigationBarHeight = self.navigationController!.navigationBar.frame.height + 20
        debugPrint(navigationBarHeight)
        mapView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(navigationBarHeight)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
            make.left.equalTo(view)
        }
    }
    func configureSearchView() {
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.delegate = self
        searchBar.placeholder = "Search for your Work"
//        let navigationBarHeight = self.navigationController!.navigationBar.frame.height
//        let searchBarFrame = CGRect(x: 0, y: navigationBarHeight + 22, width: view.frame.width, height: 44)
//        searchBar.frame = searchBarFrame
//        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        searchBar.sizeToFit()
        debugPrint("Added Search Bar View")
    }
    func displayResultsController() {
        addChildViewController(resultsController)
        view.addSubview(resultsController.view)
        resultsController.view.snp.makeConstraints{ (make) -> Void in
            make.edges.equalTo(mapView)
        }
        resultsController.didMove(toParentViewController: self)
        resultsController.mapSearchDelegate = self
    }
    func dismissResultsController() {
        resultsController.willMove(toParentViewController: nil)
        resultsController.view.removeFromSuperview()
        resultsController.removeFromParentViewController()
    }
}
extension SetWorkAddressViewController:UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.sizeToFit()
        searchBar.becomeFirstResponder()
        displayResultsController()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: true)
        searchBar.sizeToFit()
        searchBar.resignFirstResponder()
        dismissResultsController()
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        self.navigationItem.hidesBackButton = false
        searchBar.sizeToFit()
        searchBar.resignFirstResponder()
        dismissResultsController()
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}
extension SetWorkAddressViewController: addressMapSearch {
    func  dropMapPin(placemark: MKPlacemark) {
        
    }
}


