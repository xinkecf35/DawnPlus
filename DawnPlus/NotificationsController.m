//
//  NotificationsController.m
//  DawnPlus
//
//  Created by Xinke Chen on 2018-03-05.
//  Copyright © 2018 Xinke Chen. All rights reserved.
//

#import "NotificationsController.h"

@interface NotificationsController()

@property (nonatomic, nonnull, readwrite) UNUserNotificationCenter *center;
@property (nonatomic, readwrite) BOOL isBackgroundAlarmsAllowed;

@end

@implementation NotificationsController

@synthesize center, isBackgroundAlarmsAllowed;

- (void)initializeNotificationSupport {
    center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions: (UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^ (BOOL granted, NSError * _Nullable error){
        if (error) {
            NSLog(@"Error in obtaining authorization for notifications");
        }
        if(granted == YES) {
            
        } else {
            //Reports to user that this authorization needs to happen for alarms to work
        }
    }];
}

- (void)scheduleAlarmNotification: (NSDate *)time {
    
}

- (void)handleForeGroundNotification {
    
}

- (void)handleBackGroundNotification {
    
}

@end
