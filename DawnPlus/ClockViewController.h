//
//  ViewController.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/23/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationFetch.h"
#import "WeatherFetch.h"
#import "TrafficFetch.h"
#import "GeocodeFetch.h"
#import "CoreDataController.h"
#import "NotificationsController.h"
#import "AlarmTableViewController.h"

@interface ClockViewController : UIViewController {
    NSUserDefaults *defaults;
}

@property double latitude;
@property double longitude;
@property (strong, nonatomic) WeatherFetch *weatherUpdate;
@property (strong, nonatomic) TrafficFetch *trafficUpdate;
@property (strong, nonatomic) GeocodeFetch *geocodeService;
@property (strong, nonatomic) CoreDataController *coreDataManager;
@property (strong, nonatomic) NotificationsController *notificationManager;
@property (weak, nonatomic) IBOutlet UILabel *clockLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherTemperature;
@property (weak, nonatomic) IBOutlet UIButton *trafficInfo;
@property (weak, nonatomic) IBOutlet UIButton *weatherIcon;


//-(IBAction)toggleSettings:(id)sender;
//-(IBAction)toggleTrafficInfo:(id)sender;
-(IBAction)unwindToClockView:(UIStoryboardSegue*)sender;
-(void)updateClockLabel;
-(void)updateWeatherLabels;
-(void)updateTrafficLabels;
-(void)didDefaultsChange:(NSNotification *)notification;

@end

