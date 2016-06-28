//
//  TrafficFetch.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 6/25/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LocationFetch.h"

@interface TrafficFetch : NSObject
{
    double currentLatitude;
    double currentLongitude;
    double workLatitude;
    double workLongitude;
    int status;
    NSData *trafficJSON;
    NSMutableDictionary *trafficData;
   
}

+(TrafficFetch *)sharedTraffic;

@property NSString *workLocation;
@property NSArray *trafficIncidents;


-(id) initWithLocation: (double)latitude : (double)longitude;
-(void) sendTrafficRequest;
-(void) geocodeWorkLocation;
-(void) setCurrentCoordinates: (double)latitude : (double)longitude;
-(void) addTrafficIncidents;


@end
