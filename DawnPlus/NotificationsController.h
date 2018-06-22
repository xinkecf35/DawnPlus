//
//  NotificationsController.h
//  DawnPlus
//
//  Created by Xinke Chen on 2018-03-05.
//  Copyright © 2018 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import "AlarmObject+CoreDataProperties.h"
@interface NotificationsController : NSObject <UNUserNotificationCenterDelegate>

@property (nonatomic, nonnull, readonly) UNUserNotificationCenter *center;

- (id)init;
- (void)scheduleNotificationForAlarm:(AlarmObject *)alarm;
- (void)cancelNotificationForAlarms:(NSArray *)alarms;
- (void)handleForeGroundNotification;
- (void)handleBackGroundNotification;

@end
