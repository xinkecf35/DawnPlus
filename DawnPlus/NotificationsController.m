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

- (id)init {
    self = [super init];
    center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions: (UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^ (BOOL granted, NSError * _Nullable error){
        if (error) {
            NSLog(@"Error in obtaining authorization for notifications");
        }
        if(granted == YES) {
            isBackgroundAlarmsAllowed = YES;
        } else {
            isBackgroundAlarmsAllowed = NO;
        }
    }];
    return self;
}

- (void)scheduleAlarmNotification: (NSDate *)time {
    
}

- (void)handleForeGroundNotification {
    
}

- (void)handleBackGroundNotification {
    
}

// User Notification Delegate Methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
}

@end
