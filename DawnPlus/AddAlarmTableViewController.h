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
#import "DayTableViewController.h"
#import "LabelViewController.h"

@interface AddAlarmTableViewController: UITableViewController <MPMediaPickerControllerDelegate>

@property (weak, nonatomic) id <AlarmDataDelegate> alarmDelegate;
@property (strong, nonatomic) NSString *previousSoundAsset;
@property (strong, nonatomic) NSString *previousLabel;
@property (strong, nonatomic) NSArray *previousRepeatArray;

@end
