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
/*
-(id)initWithLocation:(double)longitude :(double)latitude
{
    if(self = [super init])
    {
        currentLocationLong = [NSString stringWithFormat:@"%.6f",longitude];
        currentLocationLat = [NSString stringWithFormat:@"%.6f",latitude];
    }
    return self;
}
*/
-(void)setWeatherLocation
{
    [[LocationFetch sharedInstance] addObserver:self forKeyPath:@"currentLocation" options: NSKeyValueObservingOptionNew context:nil];
}
-(void)sendWeatherRequest
{
    NSError *weatherError;
    //Setting forecast.io url
    NSLog(@"Longitude %0.6f, Latitude %0.6f",currentLocationLong,currentLocationLat);
    NSString *weatherURL = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%0.6f,%0.6f",forecastAPIKey,currentLocationLat,currentLocationLong];
    //JSON GET request
    NSData *weatherJSON = [NSData dataWithContentsOfURL:[NSURL URLWithString:weatherURL]];
    NSMutableArray *weatherData = [NSJSONSerialization JSONObjectWithData:weatherJSON options:kNilOptions error:&weatherError];
    NSLog(@"Weather Request Sent; json: %@", weatherData);
    
}
//Trigger Location Update for WeatherFetch via Key Value Observation
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentLocation"]) {
        currentLocationLat = [LocationFetch sharedInstance].currentLocation.coordinate.latitude;
        currentLocationLong = [LocationFetch sharedInstance].currentLocation.coordinate.longitude;
        NSLog(@"currentLocation is updated for WeatherFetch with Longitude: %0.6f, Latitude: %0.6f",currentLocationLong, currentLocationLat);
        
    }
}


@end

