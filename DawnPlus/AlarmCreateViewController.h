//
//  AlarmCreateViewController.h
//  DawnPlus
//
//  Created by Xinke Chen on 2017-10-01.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAlarmTableViewController.h"
#import "CoreDataController.h"
#import "AlarmDataDelegate.h"
#import "AlarmObject+CoreDataProperties.h"


@interface AlarmCreateViewController : UIViewController <UITableViewDelegate, AlarmDataDelegate>

@property (strong, nonatomic) CoreDataController *coreDataManager;
@property (strong,nonatomic) UIDatePicker *timePicker;
@property (strong, nonatomic) NSArray *daysToRepeat;
@property (strong, nonatomic) AddAlarmTableViewController *tableOptionsVC;

@end
