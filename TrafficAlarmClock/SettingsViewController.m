//
//  SettingsViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 8/25/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController 
-(void)viewDidLoad
{
    [super viewDidLoad];
    //settings = [NSArray arrayWithObjects:@"Alarm",@"Traffic",@"Weather",@"About", nil];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(IBAction)dismissSettings:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
