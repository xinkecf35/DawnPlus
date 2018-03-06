//
//  NotificationsController.h
//  DawnPlus
//
//  Created by Xinke Chen on 2018-03-05.
//  Copyright © 2018 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationsController : NSObject

- (void)initializeNotificationSupport;
- (void)scheduleAlarmNotification: (NSDate *)time;
- (void)handleForeGroundNotification;
- (void)handleBackGroundNotification;

@end
