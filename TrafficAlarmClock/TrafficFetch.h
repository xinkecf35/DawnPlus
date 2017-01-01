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
    //Actual user and work coordinates respectively
    double currentLatitude;
    double currentLongitude;
    NSData *trafficJSON;
    NSMutableDictionary *trafficData;
   
}
@property double workLatitude;
@property double workLongitude;

@property NSString *workLocation;
@property NSArray *trafficIncidents;
@property int status;


-(id) initWithLocation: (double)latitude : (double)longitude;
-(void) sendTrafficRequest;
-(void) setCurrentCoordinates: (double)latitude : (double)longitude;
-(void) addTrafficIncidents;
-(void) generateFilters: (NSNotificationCenter *)center;


@end
