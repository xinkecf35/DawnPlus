//
//  DayTableViewController.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-06-03.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlarmDataDelegate.h"

@interface DayTableViewController: UITableViewController{
    NSMutableArray *selectedDays;
}

@property (weak, nonatomic) id <AlarmDataDelegate> delegate;



@end
