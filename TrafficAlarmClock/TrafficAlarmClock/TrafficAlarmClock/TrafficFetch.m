//
//  TrafficFetch.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 6/25/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "TrafficFetch.h"
static const NSString *mapquestAPIKey = @"VHvMoKU4OTqvSQE7AfGzGniuwykvkdlY";



@implementation TrafficFetch

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
-(void)setCurrentCoordinates: (double)latitude : (double)longitude;
{
    currentLatitude = latitude;
    currentLongitude = longitude;
}
-(void)geocodeWorkLocation
{
    NSError *trafficError;
    //Geocoding workLocation
    NSURLComponents *trafficURL = [[NSURLComponents alloc]init];
    trafficURL.scheme = @"http";
    trafficURL.host = @"www.mapquestapi.com";
    trafficURL.path = @"/geocoding/v1/address";
    NSDictionary *queryParameters = @{@"key": mapquestAPIKey, @"location": self.workLocation};
    NSMutableArray *queryItems = [NSMutableArray array];
    for(NSString *key in queryParameters)
    {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryParameters[key]]];
    }
    trafficURL.queryItems = queryItems;
    NSLog(@"%@",trafficURL.URL);
    //JSON GET
    NSData *json = [NSData dataWithContentsOfURL:trafficURL.URL];
    NSMutableDictionary *geocodeData = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:&trafficError];
    //Peeling layers off to actual needed data
    NSArray *intialTransform = [geocodeData objectForKey:@"results"];
    NSDictionary *secondaryTransform = [intialTransform objectAtIndex:0];
    NSArray *location = [secondaryTransform objectForKey:@"locations"];
    NSDictionary *tertiaryTransform = [location objectAtIndex:0];
    NSDictionary *coordinates = [tertiaryTransform objectForKey:@"latLng"];
    NSNumber *geocodedLatitude = [coordinates objectForKey:@"lat"];
    NSNumber *geocodedLongitude = [coordinates objectForKey:@"lng"];
    workLatitude = [geocodedLatitude doubleValue];
    workLongitude = [geocodedLongitude doubleValue];
    //Setting coordinates for
    NSLog(@"%@ geocoded workLocation; Latitude: %0.6f, Longitude: %0.6f",self, workLatitude, workLongitude);
    
    
}


-(void)sendTrafficRequest
{
    NSError *trafficError;
    
    //Getting Traffic Information
    NSURLComponents *trafficURL = [[NSURLComponents alloc]init];
    trafficURL.scheme = @"http";
    trafficURL.host = @"www.mapquestapi.com";
    trafficURL.path = @"/traffic/v2/incidents";
}

@end