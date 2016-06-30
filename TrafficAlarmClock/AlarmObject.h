//
//  AlarmObject.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 6/29/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AlarmObject : NSObject <NSCoding>

@property NSDate *timeToSetOff;
@property BOOL enabled;
@property int notificationID;

-(void)setAlarm;


@end
