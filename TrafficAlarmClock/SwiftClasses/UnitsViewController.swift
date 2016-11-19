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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let rowToSelect:IndexPath = IndexPath(row: 1, section: 0)
        tableView.cellForRow(at: rowToSelect)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
}
