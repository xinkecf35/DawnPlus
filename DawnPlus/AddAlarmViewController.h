//
//  AddAlarmViewController.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-06-02.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CoreDataController.h"
#import "AlarmObject+CoreDataClass.h"
#import "AlarmDataDelegate.h"
#import "DayTableViewController.h"
#import "LabelViewController.h"
#import "AddAlarmTableViewController.h"

@interface AddAlarmViewController : UIViewController <AlarmDataDelegate, UITableViewDelegate>

@property (strong, nonatomic) NSArray *dayRepeat;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) CoreDataController *coreDataManager;

@end

