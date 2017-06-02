//
//  AlarmObject.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 6/29/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AlarmObject : NSManagedObject

@property NSDate *alarmTime;
@property NSArray *dayToRepeat;
@property BOOL enabled;
@property int notificationID;

-(void)setAlarm;

@end
