//
//  AddAlarmViewController.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-06-02.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CoreDataController.h"
#import "AlarmDataDelegate.h"
#import "DayTableViewController.h"
#import "LabelViewController.h"

@interface AddAlarmViewController : UIViewController <AlarmDataDelegate, UITableViewDelegate>

@property (strong, nonatomic) NSArray *dayRepeat;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) CoreDataController *coreDataManager;

@end

