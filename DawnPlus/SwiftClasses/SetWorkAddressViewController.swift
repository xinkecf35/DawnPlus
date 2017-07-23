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
    var resultsController:AddressResultsViewController!
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        resultsController = storyboard.instantiateViewController(withIdentifier: "AddressResultsTable") as! AddressResultsViewController
        addChildViewController(resultsController)
        view.addSubview(resultsController.view)
        resultsController.view.snp.makeConstraints{ (make) -> Void in
            make.edges.equalTo(mapView)
        }
        resultsController.didMove(toParentViewController: self)
        resultsController.mapView = mapView
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
        finishSearch()
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        finishSearch()
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsController.updateSearchResults(searchPhrase: searchText)
    }
    func finishSearch() {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        self.navigationItem.hidesBackButton = false
        searchBar.sizeToFit()
        searchBar.resignFirstResponder()
        dismissResultsController()
    }
}
extension SetWorkAddressViewController: addressMapSearch {
    func  dropMapPin(placemark: MKPlacemark) {
        finishSearch()
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.title
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated:true)
    }
}


