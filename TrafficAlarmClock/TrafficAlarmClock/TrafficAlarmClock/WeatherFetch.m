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
static void *weatherFetchPointer; //Here to hoping this works

@implementation WeatherFetch
-(id)initWithLocation: (double)latitude : (double)longitude
{
    if(self = [super init])
    {
        currentLocationLat = latitude;
        currentLocationLong = longitude;
        [self observeLocationFetch];
    }
    return self;
}

-(void)dealloc {
    [[LocationFetch sharedInstance] removeObserver:self forKeyPath:@"currentLocation" context:nil];
    
}

-(void)setWeatherLocation
{
    currentLocationLat = [LocationFetch sharedInstance].currentLocation.coordinate.latitude;
    currentLocationLong = [LocationFetch sharedInstance].currentLocation.coordinate.longitude;
    NSLog(@"weatherUpdate Lat: %0.6f, Long: %0.6f",currentLocationLat,currentLocationLong);
}
-(void)sendWeatherRequest
{
    NSError *weatherError;
    //Setting forecast.io url
    NSLog(@"Longitude %0.6f, Latitude %0.6f",currentLocationLong,currentLocationLat);
    NSString *weatherURL = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%0.6f,%0.6f",forecastAPIKey,currentLocationLat,currentLocationLong];
    //JSON GET request
    NSData *weatherJSON = [NSData dataWithContentsOfURL:[NSURL URLWithString:weatherURL]];
    NSMutableDictionary *weatherData = [NSJSONSerialization JSONObjectWithData:weatherJSON options:kNilOptions error:&weatherError];
    NSLog(@"Weather Request Sent; json recieved for Lat: %0.6f, Long:%0.6f",currentLocationLat,currentLocationLong);
   
    
}
@end

