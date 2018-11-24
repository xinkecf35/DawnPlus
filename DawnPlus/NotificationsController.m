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

static NSString *ALARM_CATEGORY = @"DawnPlusAlarmCategory";
static NSString *ALARM_CATEGORY_ACTION_SNOOZE = @"Snooze";
static NSString *ALARM_CATEGORY_ACTION_WAKE = @"Wake";

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
    static dispatch_once_t createCategoriesToken;
    dispatch_once(&createCategoriesToken, ^{
        [self configureNotificationCategories];
    });
    [center requestAuthorizationWithOptions: (UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^ (BOOL granted, NSError * _Nullable error){
                              if (error) {
                                  NSLog(@"Error in obtaining authorization for notifications %@",error);
                              }
                              if(granted == YES) {
                                  self.isBackgroundAlarmsAllowed = YES;
                              }
    }];
}

- (void)configureNotificationCategories {
    UNNotificationAction *snoozeAction = [UNNotificationAction actionWithIdentifier:ALARM_CATEGORY_ACTION_SNOOZE
                                                                              title:@"Snooze"
                                                                            options:UNNotificationActionOptionNone];
    UNNotificationAction *wakeAction = [UNNotificationAction actionWithIdentifier:ALARM_CATEGORY_ACTION_WAKE
                                                                            title:@"Wake Up"
                                                                          options:UNNotificationActionOptionForeground];
    
    UNNotificationCategory *alarmCategory = [UNNotificationCategory categoryWithIdentifier:ALARM_CATEGORY
                                                                                   actions:@[snoozeAction, wakeAction]
                                                                         intentIdentifiers:@[]
                                                                                   options:UNNotificationCategoryOptionNone];
    NSSet *categories = [NSSet setWithObject:alarmCategory];
    [center setNotificationCategories:categories];
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
    for (NSArray *identifiers in alarms) {
        [center removePendingNotificationRequestsWithIdentifiers:identifiers];
    }
}

- (void)scheduleNotificationForAlarm:(AlarmObject *)alarm {
    [center getNotificationSettingsWithCompletionHandler:^ (UNNotificationSettings *settings) {
        if(settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            self.isBackgroundAlarmsAllowed = YES;
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
    alarmContent.categoryIdentifier = ALARM_CATEGORY;
    // Make userInfo dictionary
    // Make the following more dynamic; implementing notification sound ramping
    alarmContent.sound = [UNNotificationSound soundNamed:@"alarm.aif"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    // Add notifications for each day of the week as needed
    for(int weekday = 0; weekday < [alarm.dayToRepeat count]; weekday++) {
        NSNumber *day = [alarm.dayToRepeat objectAtIndex:weekday];
        if([day boolValue] == NO) {
            continue;
        }
        // Creating notification trigger
        [userInfo setObject:[alarm.notificationIDs objectAtIndex:weekday] forKey:@"identifier"];
        [userInfo setObject:alarm.alarmTime forKey:@"fireDate"];
        alarmContent.userInfo = userInfo;
        NSDateComponents *alarmDate = [self getAlarmDateComponents:alarm.alarmTime:weekday];
        UNCalendarNotificationTrigger *alarmTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:alarmDate repeats:YES];
        // Creating notification request
        UNNotificationRequest *alarmRequest = [UNNotificationRequest requestWithIdentifier:[alarm.notificationIDs objectAtIndex:weekday]
                                                                                   content:alarmContent
                                                                                   trigger:alarmTrigger];
        // adding request
        [center addNotificationRequest:alarmRequest withCompletionHandler:^ (NSError *error) {
            if (error) {
                NSLog(@"Error in scheduling local notifications: %@", error);
            }
            // NSLog(@"Scheduling Request succeeeded with: %@",alarmRequest);
        }];
    }
}

- (void)handleForeGroundNotification {
    
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
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSString *requestCategoryIdentifier = response.notification.request.content.categoryIdentifier;
    if ([requestCategoryIdentifier isEqualToString:ALARM_CATEGORY]) {
        NSString *actionIdentifier  = response.actionIdentifier;
        if ([actionIdentifier isEqualToString:ALARM_CATEGORY_ACTION_SNOOZE]) {
            NSString *notificationID = [userInfo objectForKey:@"identifier"];
//            NSDate *originalFireDate = [userInfo objectForKey:@"fireDate"];
//            NSDate *snoozeFireDate = [originalFireDate dateByAddingTimeInterval:540]; // 540 = 9 minutes in seconds
            UNTimeIntervalNotificationTrigger *snoozeTrigger = [UNTimeIntervalNotificationTrigger
                                                                triggerWithTimeInterval:540
                                                                repeats:NO];
            UNNotificationRequest *snoozeRequest = [UNNotificationRequest requestWithIdentifier:notificationID
                                                                                        content:response.notification.request.content
                                                                                        trigger:snoozeTrigger];
            [center addNotificationRequest:snoozeRequest withCompletionHandler:^ (NSError *error) {
                if (error) {
                    NSLog(@"Error in scheduling snooze notificaiotions: %@", error);
                }
            }];
            
        } else if ([actionIdentifier isEqualToString:ALARM_CATEGORY_ACTION_WAKE]) {
            
        } else if ([actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]){
            
        }
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Handling notification with ID: %@",notification.request.identifier);
    completionHandler(UNNotificationPresentationOptionNone);
}

@end
