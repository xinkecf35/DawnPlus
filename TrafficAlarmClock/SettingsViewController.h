//
//  SettingsViewController.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 8/25/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LocationFetch.h"

@interface SettingsViewController : UIViewController

@property NSString *userWorkLocation;

-(void)userInputTrafficSettings;

@end
