//
//  SettingsViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 8/25/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

@synthesize gentleWakeSwitch;

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    defaults = NSUserDefaults.standardUserDefaults;
    //NSLog(@"Value from defaults %d",[defaults boolForKey:@"isGentleWake"]);
    [gentleWakeSwitch setOn:[defaults boolForKey:@"isGentleWake"]];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [gentleWakeSwitch addTarget:self action:@selector(toggleGentleWake) forControlEvents:UIControlEventValueChanged];
    //settings = [NSArray arrayWithObjects:@"Alarm",@"Traffic",@"Weather",@"About", nil];
}
-(void) viewWillDisappear:(BOOL)animated {
    [defaults synchronize];
    [super viewWillDisappear:true];
}
- (void)viewDidUnload {
    [super viewDidUnload];

}
//Handle Gentle Wake
-(void) toggleGentleWake {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [defaults setBool:gentleWakeSwitch.isOn forKey:@"isGentleWake"];
        NSLog(@"Set isGentleWake in defaults to %@", [defaults valueForKey:@"isGentleWake"]);
    });
}
//Dismiss View Controller
-(IBAction)dismissSettings:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
