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
    NSData *trafficJSON;
    NSURLSession *session;
   
}

@property (readonly) NSMutableDictionary *trafficData;
@property NSUserDefaults *userDefaults;
@property NSDictionary *coordinates;
@property NSString *workLocation;
@property NSArray *trafficIncidents;
@property (readonly) NSInteger status;

-(NSURLSessionTask *)sendTrafficRequest;
-(NSInteger)addTrafficIncidents;
-(NSInteger)rankOverallSeverity;
-(NSString *)generateFilters:(NSUserDefaults *) defaults;
-(NSURL *)generateURL:(NSUserDefaults *)defaults;


@end
