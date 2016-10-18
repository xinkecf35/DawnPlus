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

@interface GeocodeFetch : NSObject
{
    double boundingBoxLatitude;
    double boundingBoxLongitude;
    double workLatitude;
    double workLongitude;
}
@property double currentLatitude;
@property double currentLongitude;
@property NSString* inputWorkAddress;
@property NSString* verifiedAddress;


-(void) geocodeWorkLocation;
-(NSArray *)checkWorkLocation;


@end
