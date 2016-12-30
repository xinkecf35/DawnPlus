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
    //Constants
    let unitOptions : [String] = ["Fahrenheit","Celsius"]
    let defaults : UserDefaults = UserDefaults.standard
    let checkedCellsConstant : String = "isFarenheit"
    var currentUnit:Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let storedValue = defaults.object(forKey: checkedCellsConstant) as! Bool
        
        if(storedValue == true) {
            currentUnit = 0
        }
        else {
            currentUnit = 1
        }
        let storedSelection = IndexPath.init(row: currentUnit, section: 0)
        tableView.cellForRow(at: storedSelection)?.accessoryType = UITableViewCellAccessoryType.checkmark
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        defaults.synchronize()
        NSLog("Defaults for %@ saved", self)
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
    //Selection of Units
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: false)
        if(currentUnit == indexPath.row) {
            return
        }
        let oldSelection = IndexPath.init(row:currentUnit, section:0)
        
        let newCell = tableView.cellForRow(at: indexPath)
        let oldCell = tableView.cellForRow(at: oldSelection)
        
        if(newCell?.accessoryType == UITableViewCellAccessoryType.none) {
            newCell?.accessoryType = UITableViewCellAccessoryType.checkmark
            currentUnit = indexPath.row
        }
        if(oldCell?.accessoryType == UITableViewCellAccessoryType.checkmark) {
            oldCell?.accessoryType = UITableViewCellAccessoryType.none
        }
        if(currentUnit == 0) {
            defaults.set(true, forKey: checkedCellsConstant)
        }
        else {
            defaults.set(false, forKey: checkedCellsConstant)
        }
    }
    
}
