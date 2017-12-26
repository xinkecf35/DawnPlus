//
//  AlarmTableViewCell.h
//  DawnPlus
//
//  Created by Xinke Chen on 2017-12-26.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>

@interface AlarmTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmNameLabel;
- (IBAction)changeAlarmEnable:(UISwitch *)sender;

@end
