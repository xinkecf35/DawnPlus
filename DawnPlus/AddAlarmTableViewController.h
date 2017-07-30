//
//  AddAlarmTableViewController.h
//  DawnPlus
//
//  Created by Xinke Chen on 2017-07-30.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AlarmDataDelegate.h"

@interface AddAlarmTableViewController: UITableViewController <MPMediaPickerControllerDelegate>

@property (strong, nonatomic) NSString *selectedTitle;
@property (weak, nonatomic) id <AlarmDataDelegate> alarmDelegate;

@end
