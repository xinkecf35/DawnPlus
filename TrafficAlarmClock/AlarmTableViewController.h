//
//  AlarmTableViewController.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-05-17.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataController.h"
#import "AddAlarmViewController.h"
@import UIKit;
@import CoreData;

@interface AlarmTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableView *alarmTableView;
@property (strong, nonatomic) CoreDataController *coreDataManager;

@property NSArray *alarms;

@end
