//
//  DayTableViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-06-03.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "DayTableViewController.h"

@implementation DayTableViewController

@synthesize alarmDelegate,previousSelection;

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if(previousSelection != nil) {
        for(int i = 0; i < [previousSelection count]; i++) {
            if([[previousSelection objectAtIndex:i] integerValue] == 1) {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                selectedDays[i] = 1;
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 7; i++) {
        [tempArray addObject:[NSNumber numberWithInt:selectedDays[i]]];
    }
    [alarmDelegate setSelectedDays:tempArray];
    NSLog(@"Saved the following array %@", alarmDelegate.selectedDays);
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
