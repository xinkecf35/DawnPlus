//
//  AlarmTableViewCell.h
//  DawnPlus
//
//  Created by Xinke Chen on 2017-12-26.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "AlarmObject+CoreDataProperties.h"

@interface AlarmTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmNameLabel;
@property (strong, nonatomic) AlarmObject *alarm;
@property (weak, nonatomic) IBOutlet UISwitch *enableSwitch;
- (IBAction)changeAlarmEnable:(UISwitch *)sender;

@end
