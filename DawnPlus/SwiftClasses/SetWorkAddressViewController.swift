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
    var shortAddress: String?
    
    //UIKit Methods
    override func viewDidLoad() {
        coordinate = LocationFetch.sharedInstance().currentLocation.coordinate
        //Handle nil here more gracefully
        definesPresentationContext = true;
        configureMapView()
        configureSearchView()
        super.viewDidLoad()
        view.layoutSubviews()
        debugPrint(searchBar.frame)
    }
    //Configure Views
    func configureMapView() {
        let frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        mapView.frame = frame
        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        if #available(iOS 11, *) {
            mapView.snp.makeConstraints ({ (make) -> Void in
                let safeArea = view.safeAreaLayoutGuide
                make.edges.equalTo(safeArea.snp.edges)
            })
        } else {
            mapView.snp.makeConstraints({ (make) -> Void in
                make.top.equalTo(topLayoutGuide.snp.bottom)
                make.right.equalTo(view)
                make.bottom.equalTo(view)
                make.left.equalTo(view)
            })
        }
        mapView.setNeedsLayout()
    }
    func configureSearchView() {
        let frame = CGRect(x: 20, y: 40, width: 200, height: 44)
        searchBar.frame = frame
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.isTranslucent = true
        searchBar.delegate = self
        searchBar.placeholder = "Search for your Work"
        view.addSubview(searchBar)
        let searchMargin = 0
        if #available(iOS 11, *) {
            searchBar.snp.makeConstraints({(make) -> Void in
                let safeArea = view.safeAreaLayoutGuide
                make.top.equalTo(safeArea).offset(searchMargin)
                make.height.equalTo(44);
                make.left.equalTo(safeArea.snp.left).offset(searchMargin)
                make.right.equalTo(safeArea.snp.right).offset(-searchMargin)
            })
        } else {
            searchBar.snp.makeConstraints({(make) -> Void in
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(searchMargin)
                make.height.equalTo(44);
                make.left.equalTo(view.snp.left).offset(searchMargin)
                make.right.equalTo(view.snp.right).offset(-searchMargin)
            })
        }
        searchBar.setNeedsLayout()
        debugPrint("Added Search Bar View")
    }
    func displayResultsController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        resultsController = (storyboard.instantiateViewController(withIdentifier: "AddressResultsTable") as! AddressResultsViewController)
        addChild(resultsController)
        view.addSubview(resultsController.view)
        if #available(iOS 11, *) {
            resultsController.view.snp.makeConstraints({(make) -> Void in
                let safeArea = view.safeAreaLayoutGuide
                make.top.equalTo(searchBar.snp.bottom).offset(0)
                make.left.equalTo(safeArea.snp.left)
                make.right.equalTo(safeArea.snp.right)
                make.bottom.equalTo(safeArea.snp.bottom)
            })
        } else {
            resultsController.view.snp.makeConstraints({(make) -> Void in
                make.top.equalTo(searchBar.snp.bottom).offset(0)
                make.right.equalTo(view)
                make.left.equalTo(view)
                make.bottom.equalTo(view)
            })
        }
        resultsController.view.setNeedsLayout()
        resultsController.didMove(toParent: self)
        resultsController.mapView = mapView
        resultsController.mapSearchDelegate = self
        view.layoutSubviews()
    }
    func dismissResultsController() {
        resultsController.willMove(toParent: nil)
        resultsController.view.removeFromSuperview()
        resultsController.removeFromParent()
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
        let confirmAddressView = UIView()
        confirmAddressView.layer.cornerRadius = 12
        confirmAddressView.layer.masksToBounds = true;
        view.addSubview(confirmAddressView)
        //Autolayout constraints
        confirmAddressView.snp.makeConstraints({(make) -> Void in
            let edgeOffset = 10
            let confirmHeight = 108
            if #available(iOS 11, *) {
                let safeArea = view.safeAreaLayoutGuide
                make.height.equalTo(confirmHeight)
                make.left.equalTo(safeArea.snp.left).offset(edgeOffset)
                make.right.equalTo(safeArea.snp.right).offset(-edgeOffset)
                 make.bottom.equalTo(safeArea.snp.bottom).offset(-edgeOffset)
            } else {
                make.height.equalTo(confirmHeight)
                make.left.equalTo(view).offset(edgeOffset)
                make.right.equalTo(view).offset(-edgeOffset)
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-edgeOffset)
            }
            
        })
        confirmAddressView.backgroundColor = UIColor(hue: 0.14, saturation: 0.94, brightness: 0.89, alpha: 1.0)
        let buttonWidth = (view.frame.width-32)/2
        let buttonHeight = 48.0
        let buttonFont = UIFont(name: "Raleway-Medium", size: 18.0)
        //Defining Okay Button
        let okayButton = UIButton(type: .custom)
        okayButton.setTitle("OK", for:.normal)
        okayButton.titleLabel?.font = buttonFont
        okayButton.backgroundColor = UIColor(hue: 0.22, saturation: 0.76, brightness: 0.75, alpha: 1.0)
        okayButton.layer.cornerRadius = 10
        confirmAddressView.addSubview(okayButton)
        //Defining Cancel Button
        let cancelButton = UIButton(type: .custom)
        cancelButton.layer.cornerRadius = 10
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = buttonFont
        cancelButton.backgroundColor = UIColor(hue: 0.0, saturation: 0.85, brightness: 0.86, alpha: 1.0)
        confirmAddressView.addSubview(okayButton)
        confirmAddressView.addSubview(cancelButton)
        //Auto Layout Constraints for buttons
        let edgeOffset = 4
        cancelButton.snp.makeConstraints({(make) -> Void in
            make.width.equalTo(buttonWidth)
            make.right.equalTo(confirmAddressView.snp.right).offset(-edgeOffset)
            make.bottom.equalTo(confirmAddressView.snp.bottom).offset(-edgeOffset)
            make.height.equalTo(buttonHeight)
        })
        cancelButton.setNeedsLayout()
        okayButton.snp.makeConstraints({(make) -> Void in
            make.width.equalTo(buttonWidth)
            make.left.equalTo(confirmAddressView.snp.left).offset(edgeOffset)
            make.bottom.equalTo(confirmAddressView.snp.bottom).offset(-edgeOffset)
            make.height.equalTo(buttonHeight)
        })
        okayButton.setNeedsLayout()
        //Defining Label with short form address
        let addressLabel = UILabel()
        addressLabel.text = shortAddress
        addressLabel.textColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 1.0, alpha: 1.0)
        addressLabel.numberOfLines = 1
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.textAlignment = NSTextAlignment.center
        addressLabel.font = UIFont(name: "Raleway-Medium", size: 20)
        confirmAddressView.addSubview(addressLabel)
        //Address Label Constraints
        addressLabel.snp.makeConstraints({(make) -> Void in
            let textOffset = 3 * edgeOffset
            make.left.equalTo(confirmAddressView.snp.left).offset(textOffset)
            make.right.equalTo(confirmAddressView.snp.right).offset(-textOffset)
            make.height.equalTo(28)
            make.bottom.equalTo(okayButton.snp.top).offset(-textOffset)
        })
        addressLabel.setNeedsLayout()
        confirmAddressView.layoutSubviews()
        //Adding Target-Action for ViewController
        okayButton.addTarget(self, action: #selector(returnToSettingsandSaveAddress), for: UIControl.Event.touchDown)
        cancelButton.addTarget(self, action: #selector(returnToSettingsWithoutSaving), for: UIControl.Event.touchDown)
        //Adding View into SuperView
        confirmAddressView.isUserInteractionEnabled = true
        view.addSubview(confirmAddressView)
        confirmAddressView.setNeedsLayout()
        debugPrint(addressLabel.frame)
    }
}
extension SetWorkAddressViewController:UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.becomeFirstResponder()
        displayResultsController()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        searchBar.resignFirstResponder()
        dismissResultsController()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        let region = MKCoordinateRegion.init(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated:true)
        configureConfirmAddressView()
        view.layoutSubviews()
        workCoordinates = ["latitude":Double(placemark.coordinate.latitude), "longitude":Double(placemark.coordinate.longitude)]
    }
}


