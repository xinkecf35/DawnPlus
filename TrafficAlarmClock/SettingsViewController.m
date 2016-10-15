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
//UITableView methods
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [settings count];
//}
//
//-(UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *simpleTableIdentifier = @"SettingsCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    
//    cell.textLabel.text = [settings objectAtIndex:indexPath.row];
//    return cell;
//}

@end
