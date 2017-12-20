//
//  EditAlarmViewController.h
//  DawnPlus
//
//  Created by Xinke Chen on 2017-12-18.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "AlarmCreateViewController.h"

@interface EditAlarmViewController : AlarmCreateViewController <AlarmDataDelegate>

@property (strong, nonnull) AlarmObject *selectedAlarm;

@end
