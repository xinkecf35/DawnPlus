//
//  UnitsViewController.swift
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 11/18/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

import Foundation
import UIKit

class UnitsViewController: UITableViewController {
    let unitOptions : [String] = ["Fahrenheit","Celsius"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let rowToSelect:IndexPath = IndexPath(row: 0, section: 0)
        tableView.cellForRow(at: rowToSelect)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(<#T##animated: Bool##Bool#>)
    }
    //Delegate and Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unitOptions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitsCell", for: indexPath)
        
        cell.textLabel?.text = unitOptions[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.none) {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    //NSCoding
    
}
