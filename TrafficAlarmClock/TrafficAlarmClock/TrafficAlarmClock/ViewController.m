//
//  ViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/23/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize clockLabel, testLocation,latitude,longitude;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateClockLabel];
    [[LocationFetch sharedInstance] startingUpdatingLocation];
    latitude = [LocationFetch sharedInstance].currentLocation.coordinate.latitude;
    longitude = [LocationFetch sharedInstance].currentLocation.coordinate.longitude;
    [[LocationFetch sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];

    WeatherFetch *weatherUpdate = [[WeatherFetch alloc]initWithLocation:latitude :longitude];
    TrafficFetch *trafficUpdate = [[TrafficFetch alloc]initWithLocation:latitude :longitude];
    trafficUpdate.workLocation = @"600 N Ithan Ave, Bryn Mawr, PA 19010";
    
    [weatherUpdate sendWeatherRequest];
    [trafficUpdate geocodeWorkLocation];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//KVO for ViewController
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentLocation"])
    {
        latitude = [LocationFetch sharedInstance].currentLocation.coordinate.latitude;
        longitude = [LocationFetch sharedInstance].currentLocation.coordinate.longitude;
        NSLog(@"Observer has received message");
        WeatherFetch *weatherUpdate = [[WeatherFetch alloc]initWithLocation:latitude :longitude];
        [weatherUpdate sendWeatherRequest];
        [weatherUpdate setWeatherParameters];
    }
}
- (void) updateClockLabel {
    NSDateFormatter *clockFormat= [[NSDateFormatter alloc] init];
    [clockFormat setDateFormat:@"hh:mm a"];
    self.clockLabel.text = [clockFormat stringFromDate:[NSDate date]];
    [self performSelector:@selector(updateClockLabel) withObject:self afterDelay:1.0];
}

@end
