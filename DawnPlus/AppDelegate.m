//
//  AppDelegate.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/23/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataController.h"
#import "ClockViewController.h"
#import "NotificationsController.h"

@interface AppDelegate ()

@property (strong, readwrite) CoreDataController *persistenceController;
@property (strong, readwrite) NotificationsController *notificationController;

- (void)completeUserInterface;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Persistence Controller Setup
    [self setPersistenceController:[[CoreDataController alloc] initWithCallback:^{
        [self completeUserInterface];
    }]];
    [self setNotificationController:[[NotificationsController alloc] initWithCoreDataController:_persistenceController]];
    //Registering default values for keys
    NSDictionary *defaults = @{
                               @"isFarenheit": [NSNumber numberWithBool:true],
                               @"sensitivityCheckedCells" : [NSArray arrayWithObjects:
                                                             [NSNumber numberWithInt:1],[NSNumber numberWithInt:1],
                                                             [NSNumber numberWithInt:1],[NSNumber numberWithInt:1],
                                                             [NSNumber numberWithInt:1],[NSNumber numberWithInt:1], nil],
                               @"isGentleWake": [NSNumber numberWithBool:true]
                               };
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[self persistenceController] save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[self persistenceController] save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[self persistenceController] save];
}
- (void)completeUserInterface {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    ClockViewController *initialVC = [storyboard instantiateInitialViewController];
    initialVC.coreDataManager = _persistenceController;
    initialVC.notificationManager = _notificationController;
    _window.rootViewController = initialVC;
    NSLog(@"completeUserInterface method finished");
}
     
@end
