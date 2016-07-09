//
//  WeatherFetch.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/24/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "WeatherFetch.h"
static NSString *const forecastAPIKey = @"e7bf29e10af01a914761cf0ada1074a3"; //Super Duper Secret API

//static void *weatherFetchPointer; //Here to hoping this works
/*
//NSString of possible weatherConditions
static NSString * const weatherConditions = @"clear-day,clear-night,rain,snow,sleet,wind,fog,cloudy,partly-cloudy-day,partly-cloudy-night";
*/


@implementation WeatherFetch

@synthesize currentCondition,currentTemperature;
/*
+(WeatherFetch *) sharedWeather
{
    static WeatherFetch *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]initWithLocation: [LocationFetch sharedInstance].currentLocation.coordinate.latitude : [LocationFetch sharedInstance].currentLocation.coordinate.latitude];
    });
    return instance;
}
*/
-(id)initWithLocation: (double)latitude : (double)longitude
{
    self = [super init];
    if(self)
    {
        currentLatitude = latitude;
        currentLongitude = longitude;
    }
    return self;
}

-(void)setWeatherLocation: (double)latitude : (double)longitude
{
    currentLatitude = latitude;
    currentLongitude = longitude;
    NSLog(@"%@ Lat: %0.6f, Long: %0.6f",self,currentLatitude,currentLongitude);
}
-(void)sendWeatherRequest
{
    NSError *weatherError;
    //Setting forecast.io url
    NSString *weatherURL = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%0.6f,%0.6f",forecastAPIKey,currentLatitude,currentLongitude];
    //JSON GET request
    weatherJSON = [NSData dataWithContentsOfURL:[NSURL URLWithString:weatherURL]];
    weatherData = [NSJSONSerialization JSONObjectWithData:weatherJSON options:kNilOptions error:&weatherError];
    NSLog(@"Weather Request Sent; json recieved for Lat: %0.6f, Long:%0.6f",currentLatitude,currentLongitude);
    

}
-(void)setWeatherParameters
{
    //Getting current temperature, condition and precipitation probablity
    NSDictionary *currentWeather = [weatherData objectForKey:@"currently"];
    self.currentTemperature = [currentWeather objectForKey:@"temperature"];
    //Checking and Setting weather condition
    NSArray *weatherConditions = @[@"clear-day",@"clear-night",@"rain",@"snow",@"sleet",@"wind",@"fog",@"cloudy",@"partly-cloudy-day",@"partly-cloudy-night"];
    for (NSString *item in weatherConditions)
    {
        if([item isEqualToString:[currentWeather objectForKey:@"icon"]])
        {
            self.currentCondition = [currentWeather objectForKey:@"icon"];
        }
    }
    //Turn double into percentage
    NSNumber *precipitation = [weatherData objectForKey:@"precipProbability"];
    double precip = [precipitation doubleValue];
    precip *= 100;
    self.precipitationProbability = [NSString stringWithFormat:@"%0.0f %%",precip];
    
    NSLog(@"%@ Weather Parameters for %0.6f,%0.6f Temperature: %@, Condition:%@ Precipitation: %@", self,currentLatitude,currentLongitude,self.currentTemperature, self.currentCondition,self.precipitationProbability);
}

@end

