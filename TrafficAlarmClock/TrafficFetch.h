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
    double workLatitude;
    double workLongitude;
    //Bounding Box Cooridinates
    /*
    double homeBoundingBoxLatitude;
    double homeBoundingBoxLongitude;
    double workBoundingBoxLatitude;
    double workBoundingBoxLongitude;
    */
    int status;
    NSData *trafficJSON;
    NSMutableDictionary *trafficData;
   
}


@property NSString *workLocation;
@property NSArray *trafficIncidents;


-(id) initWithLocation: (double)latitude : (double)longitude;
-(void) sendTrafficRequest;
-(void) geocodeWorkLocation;
-(NSArray *)checkWorkLocation :(NSString *)userInput;
-(void) setCurrentCoordinates: (double)latitude : (double)longitude;
-(void) addTrafficIncidents;


@end
