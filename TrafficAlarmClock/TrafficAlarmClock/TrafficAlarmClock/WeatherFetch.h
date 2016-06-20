//
//  WeatherFetch.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/24/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//
#import "LocationFetch.h"

@interface WeatherFetch : NSObject {
    double currentTemp;
    NSString *currentLocationLong;
    NSString *currentLocationLat;
    NSData *weatherJSON;
    NSMutableArray *weatherData;
}

@property NSString *currentTemperature;
@property NSString *currentConditions;

-(id) initWithLocation:(double)longitude : (double)latitude;

-(void)setWeatherLocation:(NSString *) longitude : (NSString *) latitude;
-(void)sendWeatherRequest;



@end
