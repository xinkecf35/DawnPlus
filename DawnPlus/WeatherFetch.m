//
//  WeatherFetch.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/24/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "WeatherFetch.h"
#import "constants.m"

@implementation WeatherFetch

@synthesize weatherData,currentCondition,currentTemperature,precipitationProbability,isFarenheit,status,defaults;

-(id)init {
    self = [super init];
    if(self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

-(id)initWithLocation: (double)latitude : (double)longitude
{
    self = [super init];
    if(self)
    {
        currentLatitude = latitude;
        currentLongitude = longitude;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

-(void)setWeatherLocation: (double)latitude : (double)longitude
{
    currentLatitude = latitude;
    currentLongitude = longitude;
    NSLog(@"%@ Lat: %0.6f, Long: %0.6f",self,currentLatitude,currentLongitude);
}

-(NSURLSessionDataTask *)sendWeatherRequest
{
    //Setting desired units from NSUserDefaults
    isFarenheit = [defaults objectForKey:@"isFarenheit"];
    NSString *units = @"us";
    if([isFarenheit boolValue] == false) units = @"si";
    //Setting darksky.net url
    NSString *requestURLString = [NSString stringWithFormat:@"https://api.darksky.net/forecast/%@/%0.6f,%0.6f?units=%@",DARK_SKY_KEY,currentLatitude,currentLongitude,units];
    NSURL *weatherURL = [NSURL URLWithString:requestURLString];
    //JSON GET request with NSURLSession
    NSURLSessionDataTask *requestTask = [session dataTaskWithURL:weatherURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            status = httpResponse.statusCode;
            if([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *JSONError;
                [self willChangeValueForKey:@"weatherData"];
                weatherData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                if (JSONError) {
                    NSLog(@"JSON serialization screwed up for some reason");
                } else {
                    NSLog(@"Success on serialization, status: %ld", (long)status);
                    [self didChangeValueForKey:@"weatherData"];
                }
            } else {
                NSLog(@"Request failed, following HTTP status code: %ld(long)", (long)status);
            }
        } else {
            NSLog(@"Error on data task for WeatherFetch %@",error);
        }
    }];
    NSLog(@"Requesttask is %@",requestTask);
    [requestTask resume];
    return requestTask;
}
-(void)setWeatherParameters
{
    if([weatherData count] > 0)
    {
        //Getting current temperature, condition and precipitation probablity
        NSDictionary *currentWeather = [weatherData objectForKey:@"currently"];
        double temperature = [[currentWeather objectForKey:@"temperature"] doubleValue];
        int roundedTemperature = (int)ceil(temperature);
        currentTemperature = [NSString stringWithFormat:@"%i",roundedTemperature];
        //Checking and Setting weather condition
        NSArray *weatherConditions = @[@"clear-day",@"clear-night",@"rain",@"snow",@"sleet",@"wind",@"fog",@"cloudy",@"partly-cloudy-day",@"partly-cloudy-night"];
        for (NSString *item in weatherConditions)
        {
            if([item isEqualToString:[currentWeather objectForKey:@"icon"]])
            {
                currentCondition = [currentWeather objectForKey:@"icon"];
            }
        }
        //Turn double into percentage
        NSNumber *precipitation = [weatherData objectForKey:@"precipProbability"];
        double precip = [precipitation doubleValue];
        precip *= 100;
        precipitationProbability = [NSString stringWithFormat:@"%0.0f %%",precip];
        
        NSLog(@"%@ Weather Parameters for %0.6f,%0.6f Temperature: %@, Condition:%@ Precipitation: %@", self,currentLatitude,currentLongitude,self.currentTemperature, self.currentCondition,self.precipitationProbability);
    }
}

@end

