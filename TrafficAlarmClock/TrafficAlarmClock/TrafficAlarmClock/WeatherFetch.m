//
//  WeatherFetch.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/24/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherFetch.h"
static NSString *const forecastAPIKey = @"e7bf29e10af01a914761cf0ada1074a3"; //Super Duper Secret API

@implementation WeatherFetch : NSObject

-(id)initWithLocation:(double)longitude :(double)latitude
{
    if(self = [super init])
    {
        currentLocationLong = [NSString stringWithFormat:@"%.6f",longitude];
        currentLocationLat = [NSString stringWithFormat:@"%.6f",latitude];
    }
    return self;
}

-(void)setWeatherLocation: (NSString *)longitude : (NSString *) latitude
{
    currentLocationLat = latitude;
    currentLocationLong = longitude;
}
-(void)sendWeatherRequest
{
    NSError *weatherError;
    //Setting forecast.io url
    NSLog(@"Longitude %@, Latitude %@",currentLocationLong,currentLocationLat);
    NSString *weatherURL = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%@,%@",forecastAPIKey,currentLocationLat,currentLocationLong];
    //JSON GET request
    NSData *weatherJSON = [NSData dataWithContentsOfURL:[NSURL URLWithString:weatherURL]];
    NSMutableArray *weatherData = [NSJSONSerialization JSONObjectWithData:weatherJSON options:kNilOptions error:&weatherError];
    NSLog(@"Weather Request Sent; json: %@", weatherData);
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentLocation"]) {
    }
}

@end

