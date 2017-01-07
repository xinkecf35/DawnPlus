//
//  LocationFetch.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/27/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "LocationFetch.h"

@implementation LocationFetch

@synthesize locationManager, currentLocation, longitude, latitude;

+(LocationFetch *) sharedInstance {
    static LocationFetch *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        });
    return instance;
}
- (id)init
{
    self = [super init];
    if(self) {
        
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 100;
        self.locationManager.delegate = self;
        //Request Authorization
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}
- (void)startingUpdatingLocation {
    [self.locationManager startUpdatingLocation];
    NSLog(@"Starting Location Updates");
}
-(void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
     NSLog(@"Stopping Location Updates");
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location updates failed with %@", error);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;
    self.currentLocation = location;
    NSLog(@"LocationFetch sharedInstance: Latitude %+.6f, Longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
}



@end
