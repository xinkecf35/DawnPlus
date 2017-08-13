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

@property NSUserDefaults *userDefaults;
@property NSDictionary *coordinates;
@property NSString *workLocation;
@property NSArray *trafficIncidents;
@property int status;

-(void)sendTrafficRequest;
-(NSURL *)generateURL:(NSUserDefaults *)defaults;
-(NSInteger)addTrafficIncidents;
-(NSString *)generateFilters:(NSUserDefaults *) defaults;


@end
