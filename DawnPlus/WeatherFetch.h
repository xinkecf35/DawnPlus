//
//  WeatherFetch.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/24/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationFetch.h"

@interface WeatherFetch : NSObject {
    double currentLongitude;
    double currentLatitude;
    NSData *weatherJSON;
    NSMutableDictionary *weatherData;
}

@property (nonatomic) NSUserDefaults *defaults;
@property (nonatomic, readonly) NSString *currentTemperature;
@property (nonatomic, readonly) NSString *currentCondition;
@property (nonatomic, readonly) NSString *precipitationProbability;
@property (nonatomic, readonly) NSNumber *isFarenheit;

-(void)setWeatherLocation: (double)latitude : (double)longitude;
-(void)sendWeatherRequest;
-(void)setWeatherParameters;
-(id)initWithLocation: (double)latitude : (double)longitude;



@end
