//
//  SensitivityViewController.swift
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 11/17/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

import Foundation
import UIKit

class SensitivityViewController: UITableViewController {
    //Constants and Default values
    let trafficOptions : [String] = ["Incidents","Events","Congestion","Construction"]
    let checkedCellsConstant : String = "sensitivityCheckedCells"
    let defaults : UserDefaults = UserDefaults.standard
    var checkedCells: [Int] = [0,0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    //Initialize and Destroying Scene methods
    required convenience init() {
        self.init()
        checkedCells = defaults.object(forKey: checkedCellsConstant) as! [Int]
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        defaults.set(checkedCells, forKey: checkedCellsConstant)
        NSLog("Defaults for %@ saved", self)
    }
    //Delegate and Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trafficOptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sensitivityCell", for: indexPath)
        cell.textLabel?.text = trafficOptions[indexPath.row]
        return cell
    }
    
    //Multiple Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: false)
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.none) {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            checkedCells[indexPath.row] = 1
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            checkedCells[indexPath.row] = 0
        }
    }
    
}
