//
//  AlarmTableViewController.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-05-17.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataController.h"
#import "AlarmObject+CoreDataClass.h"
#import "AddAlarmViewController.h"
#import "EditAlarmViewController.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"

@import UIKit;
@import CoreData;

@interface AlarmTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, MGSwipeTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *alarmTableView;
@property (strong, nonatomic) CoreDataController *coreDataManager;
@property (strong, nonatomic) NSFetchedResultsController *alarmResultsController;

//@property NSArray *alarms;

@end
