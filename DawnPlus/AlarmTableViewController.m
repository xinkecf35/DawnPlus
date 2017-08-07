//
//  AlarmTableViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-05-17.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "AlarmTableViewController.h"

@implementation AlarmTableViewController

@synthesize alarms, alarmTableView;

-(void)viewDidLoad {
    [alarmTableView registerClass:UITableViewCell.self forCellReuseIdentifier:@"alarmCell"];
}

-(void)initializeFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AlarmObject"];
    
}

//TableDataSource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return alarms.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alarmCell" forIndexPath:indexPath];
    NSManagedObject *alarm = alarms[indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"alarmCell" forIndexPath:indexPath];
    //Date Format for label
    NSDateFormatter *clockFormat= [[NSDateFormatter alloc] init];
    [clockFormat setDateFormat:@"h:mm a"];
    NSString *alarmTime = [clockFormat stringFromDate:[alarm valueForKey:@"alarmTime"]];
    cell.textLabel.text = alarmTime;
    
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"AddAlarmSegue"]) {
        AddAlarmViewController *addAlarmVC = segue.destinationViewController;
        addAlarmVC.coreDataManager = self.coreDataManager;
    }
}

@end
