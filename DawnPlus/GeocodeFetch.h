//
//  geocodeFetch.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 10/9/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

//Purpose of this class is to provide Geocoded Location data for TrafficFetch
//Also to calculate Great Circle Distance between two coordinates in order
//to size an appropriate boundingBox for TrafficFetch

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationFetch.h"

@interface GeocodeFetch : NSObject

@property double currentLatitude;
@property double currentLongitude;
@property double workLatitude;
@property double workLongitude;
@property NSString* workAddress;

-(void)geocodeWorkLocation;
-(double)distanceBetweenCoordinates;
-(NSDictionary *)midpointBetweenCoordinates;
-(NSDictionary *)boundingBoxCalculations;
-(NSArray *)checkWorkLocation;


@end
