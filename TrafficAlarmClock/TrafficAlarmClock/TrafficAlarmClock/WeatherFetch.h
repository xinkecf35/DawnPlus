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
    double currentLocationLong;
    double currentLocationLat;
    NSData *weatherJSON;
    NSMutableArray *weatherData;
}

@property NSString *currentTemperature;
@property NSString *currentConditions;


-(void)setWeatherLocation;
-(void)observeLocationFetch;
-(void)sendWeatherRequest;
-(id)initWithLocation: (double) latitude : (double)longitude;



@end
