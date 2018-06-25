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

@synthesize center, isBackgroundAlarmsAllowed, coreDataManager;

- (id)init {
    self = [super init];
    coreDataManager = nil;
    [self initializeNotificationsSupport];
    return self;
}

- (id)initWithCoreDataController:(CoreDataController *)coreDataController {
    self = [super init];
    coreDataManager = coreDataController;
    [self initializeNotificationsSupport];
    return self;
}

- (void)initializeNotificationsSupport {
    isBackgroundAlarmsAllowed = NO;
    center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions: (UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^ (BOOL granted, NSError * _Nullable error){
                              if (error) {
                                  NSLog(@"Error in obtaining authorization for notifications %@",error);
                              }
                              if(granted == YES) {
                                  isBackgroundAlarmsAllowed = YES;
                              }
    }];
}

- (void)scheduleNotificationsForAlarms {
    // Fetch Alarm Objects
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AlarmObject"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"enabled = %@", @YES];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *alarms = [coreDataManager.managedObjectContext executeFetchRequest:request error:&error];
    if(error != nil) {
        NSLog(@"%@",error);
    }
    for (AlarmObject *alarm in alarms) {
        [self scheduleNotificationForAlarm:alarm];
    }
    
}

- (void)cancelPendingNotificationsForAlarms:(NSArray *)alarms {
    if(alarms == nil || alarms.count == 0) {
        return;
    }
    for (NSString *alarmLabel in alarms) {
        [self cancelNotificationsForAlarmLabel:alarmLabel];
        NSLog(@"Removed otifications for alarm with label: %@", alarmLabel);
    }
}

- (void)cancelNotificationsForAlarmLabel:(NSString *)alarmLabel {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AlarmObject"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"label = %@", alarmLabel];
    request.predicate = predicate;
    NSError *predicateError = nil;
    NSArray *alarms = [coreDataManager.managedObjectContext executeFetchRequest:request error:&predicateError];
    if(predicateError) {
        NSLog(@"%@",predicateError);
    }
    for (AlarmObject *alarm in alarms) {
        [center removePendingNotificationRequestsWithIdentifiers:alarm.notificationIDs];
    }
}

- (void)scheduleNotificationForAlarm:(AlarmObject *)alarm {
    [center getNotificationSettingsWithCompletionHandler:^ (UNNotificationSettings *settings) {
        if(settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            isBackgroundAlarmsAllowed = YES;
        }
    }];
    if(isBackgroundAlarmsAllowed == NO) {
        // Notifications not available
        return;
    }
    // Creating content for notifications
    UNMutableNotificationContent *alarmContent = [[UNMutableNotificationContent alloc] init];
    alarmContent.title = alarm.label;
    alarmContent.body = @"Wake up!";
    // Replace once notifications are working
    alarmContent.sound = [UNNotificationSound defaultSound];
    // Add notifcations for each day of the week as needed
    for(int weekday = 0; weekday < [alarm.dayToRepeat count]; weekday++) {
        NSNumber *day = [alarm.dayToRepeat objectAtIndex:weekday];
        if([day boolValue] == NO) {
            continue;
        }
        // Creating notification trigger
        NSDateComponents *alarmDate = [self getAlarmDateComponents:alarm.alarmTime:weekday];
        UNCalendarNotificationTrigger *alarmTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:alarmDate repeats:YES];
        // Creating notification request
        UNNotificationRequest *alarmRequest = [UNNotificationRequest requestWithIdentifier:[alarm.notificationIDs objectAtIndex:weekday]
                                                                                   content:alarmContent trigger:alarmTrigger];
        // adding request
        [center addNotificationRequest:alarmRequest withCompletionHandler:^ (NSError *error) {
            if(error) {
                NSLog(@"Error in scheduling local notifications: %@", error);
            }
            // NSLog(@"Scheduling Request succeeeded with: %@",alarmRequest);
        }];
    }
}

- (void)handleForeGroundNotification {
    
}

- (void)handleBackGroundNotification {
    
}

- (NSDateComponents *)getAlarmDateComponents:(NSDate *)date :(NSInteger)weekday{
    if(!date) {
        return nil;
    }
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *triggerDate = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    triggerDate.weekday = weekday + 1; // Plus one offset as weekday in NSDateComponents starts at 1
    return triggerDate;
}

// User Notification Delegate Methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Handling notification with ID: %@",notification.request.identifier);
}

@end
