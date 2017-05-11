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

-(void)viewDidLoad {
    [super viewDidLoad];
    [gentleWakeSwitch addTarget:self action:@selector(toggleGentleWake) forControlEvents:UIControlEventValueChanged];
    //settings = [NSArray arrayWithObjects:@"Alarm",@"Traffic",@"Weather",@"About", nil];
}
- (void)viewDidUnload {
    [super viewDidUnload];

}
//Handle Gentle Wake
-(void) toggleGentleWake {
    NSLog(@"Value of Gentle Wake Switch %d", gentleWakeSwitch.isOn);
}
//Dismiss View Controller
-(IBAction)dismissSettings:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
