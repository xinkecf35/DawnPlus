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
    NSData *trafficJSON;
    NSMutableDictionary *trafficData;
}
@property NSString *workLocation;
@property NSString *trafficCondition;
@property NSString *transitTime;

@end
