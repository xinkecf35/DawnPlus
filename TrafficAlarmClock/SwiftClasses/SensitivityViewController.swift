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
    //Constants
    let trafficOptions : [String] = ["Incidents","Events","Congestion","Construction"]
    var checkedCells: [Int] = [0,0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = documents[0]
        super.viewWillDisappear(<#T##animated: Bool##Bool#>)
        NSKeyedArchiver.archiveRootObject(checkedCells, toFile: filePath)
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
        if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.none) {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            checkedCells[indexPath.row] = 1
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            checkedCells[indexPath.row] = 0
        }
    }
    //NSCoding methods
    override func encode(with sensitivityCoder: NSCoder) {
        sensitivityCoder.encode(self.checkedCells, forKey: "checkedCells")
    }
}
