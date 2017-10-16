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
    var workCoordinates:[String:Double]? = nil
    
    //UIKit Methods
    override func viewDidLoad() {
        coordinate = LocationFetch.sharedInstance().currentLocation.coordinate
        //Handle nil here more gracefully
        definesPresentationContext = true;
        configureSearchView()
        configureMapView()
        super.viewDidLoad()
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
    @objc func returnToSettingsandSaveAddress() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            if(self.workCoordinates != nil) {
                self.defaults.set(self.workCoordinates, forKey: "workLocation")
                let latitude = self.workCoordinates!["latitude"]!
                let longitude = self.workCoordinates!["longitude"]!
                NSLog("%@ workLocation saved to Defaults; latitude: %0.6f, longitude: %0.6f", self, latitude,longitude)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    @objc func returnToSettingsWithoutSaving() {
        NSLog("%@ workLocation is not saved ", self)
        navigationController?.popViewController(animated: true)
    }
    func configureConfirmAddressView() {
        //Creating Parent View for Buttons
        let frame = CGRect(x: 0.0, y: view.frame.height - 54.0, width: view.frame.width, height: 54.0)
        let confirmAddressView = UIView(frame: frame)
        confirmAddressView.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 1.0)
        let buttonWidth = view.frame.width/2
        let buttonHeight = 54.0
        let leftFrame = CGRect(x: 0.0, y: 0.0, width: Double(buttonWidth), height: buttonHeight)
        let rightFrame = CGRect(x: Double(buttonWidth), y: 0.0, width: Double(buttonWidth), height: buttonHeight)
        //Defining Okay Button
        let okayButton = UIButton(type: .custom)
        okayButton.frame = leftFrame
        okayButton.setTitle("OK", for:.normal)
        okayButton.backgroundColor = UIColor(hue: 0.22, saturation: 0.74, brightness: 0.8, alpha: 1.0)
        confirmAddressView.addSubview(okayButton)
        //Defining Cancel Button
        let cancelButton = UIButton(type: .custom)
        cancelButton.frame = rightFrame
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = UIColor(hue: 0.0, saturation: 0.85, brightness: 0.86, alpha: 1.0)
        confirmAddressView.addSubview(cancelButton)
        //Adding Target-Action for ViewController
        okayButton.addTarget(self, action: #selector(returnToSettingsandSaveAddress), for: UIControlEvents.touchDown)
        cancelButton.addTarget(self, action: #selector(returnToSettingsWithoutSaving), for: UIControlEvents.touchDown)
        //Adding View into SuperView
        confirmAddressView.isUserInteractionEnabled = true
        view.addSubview(confirmAddressView)
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
        configureConfirmAddressView()
        workCoordinates = ["latitude":Double(placemark.coordinate.latitude), "longitude":Double(placemark.coordinate.longitude)]
    }
}


