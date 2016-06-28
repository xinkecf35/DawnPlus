//
//  LocationFetch.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/28/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationFetch : NSObject <CLLocationManagerDelegate>

+(LocationFetch *) sharedInstance;

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property double latitude;
@property double longitude;

-(void)startingUpdatingLocation;
-(void)stopUpdatingLocation;

@end