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
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    UIView *customSelectionView = [[UIView alloc] init];
    customSelectionView.backgroundColor = [UIColor colorWithRed:227/255.0 green:196/255.0 blue:13/255.0 alpha:1.0];
    cell.selectedBackgroundView = customSelectionView;
    return cell;
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
