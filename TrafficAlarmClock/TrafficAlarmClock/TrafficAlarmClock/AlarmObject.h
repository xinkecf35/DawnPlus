//
//  AlarmObject.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 6/3/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AlarmObject : NSObject <NSCoding>

@property(nonatomic,strong) NSString * label;
@property(nonatomic,strong) NSDate * timeToSetOff;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic,assign) int notificationID;

@end
