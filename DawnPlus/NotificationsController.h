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
#import "CoreDataController.h"
@interface NotificationsController : NSObject <UNUserNotificationCenterDelegate>

@property (nonatomic, nonnull, readonly) UNUserNotificationCenter *center;
@property (nonatomic, nonnull, readwrite) CoreDataController *coreDataManager;

- (id)initWithCoreDataController:(CoreDataController *)coreDataController;
- (void)scheduleNotificationsForAlarms;
- (void)cancelPendingNotificationsForAlarms:(NSArray *)alarms;
- (void)scheduleNotificationsForBackground;
- (void)scheduleNotificationForAppTermination;

@end
