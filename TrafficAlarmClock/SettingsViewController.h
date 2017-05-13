//
//  SettingsViewController.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 8/25/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Foundation/Foundation.h"

@interface SettingsViewController : UITableViewController {
    NSUserDefaults *defaults;
}

@property (weak, nonatomic) IBOutlet UISwitch *gentleWakeSwitch;

-(void)toggleGentleWake;


@end
