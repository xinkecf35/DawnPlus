//
//  AddressResultsViewController.swift
//  DawnPlus
//
//  Created by Hackintosh on 7/2/17.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

import Foundation
import UIKit

class AddressResultsViewController:UITableViewController {
    var setAddressController: SetWorkAddressViewController!
}
extension AddressResultsViewController:UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
    }
}
