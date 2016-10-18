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

@interface ClockViewController : UIViewController

@property double latitude;
@property double longitude;
@property (nonatomic, strong) WeatherFetch *weatherUpdate;
@property (nonatomic, strong) TrafficFetch *trafficUpdate;
@property (nonatomic, strong) GeocodeFetch *geocodeService;
@property (weak, nonatomic) IBOutlet UILabel *clockLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherTemperature;
@property (weak, nonatomic) IBOutlet UIButton *trafficInfo;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;


//-(IBAction)toggleSettings:(id)sender;
//-(IBAction)toggleTrafficInfo:(id)sender;
-(IBAction)unwindToClockView:(UIStoryboardSegue*)sender;
-(void)updateClockLabel;
-(void)updateWeatherLabels;
-(void)updateTrafficLabels;

@end

