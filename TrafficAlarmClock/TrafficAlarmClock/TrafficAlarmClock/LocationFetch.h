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

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property NSString *longitude;
@property NSString *latitude;

-(void)startingUpdatingLocation;
-(void)stopUpdatingLocation;

@end