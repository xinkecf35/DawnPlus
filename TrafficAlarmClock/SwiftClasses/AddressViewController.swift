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

protocol HandleMapSearch {
    func dropMapPin (placemark: MKPlacemark)
}

class AddressViewController: UIViewController {
    //Properties
    var latitude:Double = 0
    var longitude:Double = 0
    var addressSearchController:UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad();
        //LocationFetch location set and add observer
        latitude = LocationFetch.sharedInstance().latitude
        longitude = LocationFetch.sharedInstance().longitude
        LocationFetch.sharedInstance().addObserver(self, forKeyPath: #keyPath(LocationFetch.currentLocation), options: .new, context: nil)
        debugPrint("\(self) current location is: \(latitude), \(longitude)")
        //Setting MapView
        let span = MKCoordinateSpan(latitudeDelta: 0.05,longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: LocationFetch.sharedInstance().currentLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        //Setting Search Bar and Results table view
        let addressSearchTable = storyboard!.instantiateViewController(withIdentifier: "AddressSearchTable") as! AddressSearchTable
        addressSearchController = UISearchController(searchResultsController: addressSearchTable)
        addressSearchController?.searchResultsUpdater = addressSearchTable
        let searchBar = addressSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for your Work"
        navigationItem.titleView = addressSearchController?.searchBar
        addressSearchController?.hidesNavigationBarDuringPresentation = false
        addressSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        addressSearchTable.mapView = mapView
        addressSearchTable.handleMapSearchDelegate = self
    }
    func getDirections() {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
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
//Dropping pin for of selected address
extension AddressViewController: HandleMapSearch {
    func dropMapPin(placemark: MKPlacemark) {
        selectedPin = placemark
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
//Setting pin to set button to open Maps
extension AddressViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor  annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil if user location is being drawn
            return nil
        }
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 0, y:0), size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(AddressViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
        
    }
}
