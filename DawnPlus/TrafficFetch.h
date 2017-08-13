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
    //NSData *trafficJSON;
    NSMutableDictionary *trafficData;
    NSURLSession *session;
   
}

@property NSDictionary *coordinates;
@property NSString *workLocation;
@property NSArray *trafficIncidents;
@property int status;

-(void)sendTrafficRequest;
-(NSInteger)addTrafficIncidents;
-(NSString *)generateFilters:(NSUserDefaults *) defaults;


@end
