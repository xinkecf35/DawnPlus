//
//  DayTableViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-06-03.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "DayTableViewController.h"

@implementation DayTableViewController

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        
}

@end
