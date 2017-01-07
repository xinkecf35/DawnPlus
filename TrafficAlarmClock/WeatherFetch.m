//
//  WeatherFetch.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/24/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "WeatherFetch.h"
static NSString *const darkskyAPIKey = @"e7bf29e10af01a914761cf0ada1074a3"; //Super Duper Secret API

@implementation WeatherFetch

@synthesize currentCondition,currentTemperature,isFarenheit;

-(id)initWithLocation: (double)latitude : (double)longitude {
    self = [super init];
    if(self) {
        currentLatitude = latitude;
        currentLongitude = longitude;
    }
    return self;
}

-(void)setWeatherLocation: (double)latitude : (double)longitude {
    currentLatitude = latitude;
    currentLongitude = longitude;
}

-(void)sendWeatherRequest {
    //Setting desired units from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    isFarenheit = [defaults objectForKey:@"isFarenheit"];
    NSString *units = @"us";
    if([isFarenheit boolValue] == false) {
        units = @"si";
    }
    
    NSError *weatherError = nil;
    //Setting darksky.net url
    NSString *weatherURL = [NSString stringWithFormat:@"https://api.darksky.net/forecast/%@/%0.6f,%0.6f?units=%@",darkskyAPIKey,currentLatitude,currentLongitude,units];
    //JSON GET request
    weatherJSON = [NSData dataWithContentsOfURL:[NSURL URLWithString:weatherURL]];
    if(weatherJSON.length > 0) {
        weatherData = [NSJSONSerialization JSONObjectWithData:weatherJSON options:kNilOptions error:&weatherError];
        NSLog(@"Weather Request Sent; json recieved for Lat: %0.6f, Long:%0.6f",currentLatitude,currentLongitude);
    }
    else {
        NSLog(@"WeatherFetch is unable to fetch weather data");
    }
}
-(void)setWeatherParameters
{
    if([weatherData count] > 0) {
        //Getting current temperature, condition and precipitation probablity
        NSDictionary *currentWeather = [weatherData objectForKey:@"currently"];
        double temperature = [[currentWeather objectForKey:@"temperature"] doubleValue];
        int roundedTemperature = (int)ceil(temperature);
        self.currentTemperature = [NSString stringWithFormat:@"%i",roundedTemperature];
        //Checking and Setting weather condition
        NSArray *weatherConditions = @[@"clear-day",@"clear-night",@"rain",@"snow",@"sleet",@"wind",@"fog",@"cloudy",@"partly-cloudy-day",@"partly-cloudy-night"];
        for (NSString *item in weatherConditions) {
            if([item isEqualToString:[currentWeather objectForKey:@"icon"]]) {
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
}

@end

