//
//  DayTableViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-06-03.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "DayTableViewController.h"

@implementation DayTableViewController

@synthesize alarmDelegate;

-(void)viewDidLoad {
    [super viewDidLoad];
    
   
}
-(void)viewWillDisappear:(BOOL)animated {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 7; i++) {
        [tempArray addObject:[NSNumber numberWithInt:selectedDays[i]]];
    }
    alarmDelegate.selectedDays = tempArray;
    NSLog(@"Saved the following array %@", tempArray);
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedDays[indexPath.row] = 1;
        
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        selectedDays[indexPath.row] = 0;
    }
        
}

@end
