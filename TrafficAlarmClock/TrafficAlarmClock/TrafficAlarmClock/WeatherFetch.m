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
//NSString of possible weatherConditions
static NSString * const weatherConditions = @"clear-day,clear-night,rain,snow,sleet,wind,fog,cloudy,partly-cloudy-day,partly-cloudy-night";

@implementation WeatherFetch

@synthesize currentCondition,currentTemperature;
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

-(void)setWeatherLocation
{
    currentLatitude = [LocationFetch sharedInstance].currentLocation.coordinate.latitude;
    currentLongitude = [LocationFetch sharedInstance].currentLocation.coordinate.longitude;
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
    //Checking and Seting weather condition
    NSArray *weatherConditionsArray = [weatherConditions componentsSeparatedByString:@","];
    for (NSString *item in weatherConditionsArray)
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
    
    NSLog(@"%@ Temperature: %@, Condition:%@ Precipitation: %@", self, self.currentTemperature, self.currentCondition,self.precipitationProbability);
}

@end

