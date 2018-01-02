//
//  AlarmDataDelegate.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-06-04.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlarmDataDelegate <NSObject>

@property NSArray *selectedDays;
@property NSString *alarmName;
@property NSString *soundAsset;
@property NSNumber *enabled;
@property NSNumber *appTones;
@property NSDate *selectedTime;
@property NSNumber *notificationID;

@optional

-(void)saveToCoreData;
-(void)fetchFromCoreData;

@end
