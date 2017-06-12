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
    var checkedCells:[Int] = [0,0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkedCells = defaults.object(forKey: checkedCellsConstant) as! [Int]
        for(index, element) in checkedCells.enumerated() {
            if(element == 1) {
                let selectedRow = IndexPath.init(row: index, section: 0)
                let selectedCell = tableView.cellForRow(at: selectedRow)
                selectedCell?.accessoryType = UITableViewCellAccessoryType.checkmark;
            }
            
        }
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.defaults.set(self.checkedCells, forKey: self.checkedCellsConstant)
            DispatchQueue.main.async {
                super.viewWillDisappear(true)
            }
        }
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
        //Setting Custom Color
        let customSelectionView = UIView()
        customSelectionView.backgroundColor = UIColor.init(colorLiteralRed: 227/255.0, green: 196/255.0, blue: 13/255.0, alpha: 1.0)
        cell.selectedBackgroundView = customSelectionView;
        //Setting Text
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
