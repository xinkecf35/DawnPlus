//
//  NotificationsController.h
//  DawnPlus
//
//  Created by Xinke Chen on 2018-03-05.
//  Copyright © 2018 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface NotificationsController : NSObject <UNUserNotificationCenterDelegate>

@property (nonatomic, nonnull, readonly) UNUserNotificationCenter *center;

- (id)init;
- (void)scheduleAlarmNotification: (NSDate * _Nonnull)time;
- (void)handleForeGroundNotification;
- (void)handleBackGroundNotification;

@end
