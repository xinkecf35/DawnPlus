//
//  geocodeFetch.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 10/9/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "GeocodeFetch.h"
static const NSString *mapquestAPIKey = @"VHvMoKU4OTqvSQE7AfGzGniuwykvkdlY"; //Mapquest API Key

@implementation GeocodeFetch
@synthesize currentLatitude,currentLongitude,workLatitude,workLongitude, workAddress;

//Code from here on is all part of the Mapquest Geocode API
-(void)geocodeWorkLocation
{
    NSError *geocodeError;
    //Geocoding workLocation
    NSURLComponents *geocodeURL = [[NSURLComponents alloc]init];
    //Generating URL for Mapquest API Call
    geocodeURL.scheme = @"http";
    geocodeURL.host = @"www.mapquestapi.com";
    geocodeURL.path = @"/geocoding/v1/address";
    NSDictionary *queryParameters = @{@"key": mapquestAPIKey, @"location": workAddress};
    NSMutableArray *queryItems = [NSMutableArray array];
    for(NSString *key in queryParameters)
    {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryParameters[key]]];
    }
    geocodeURL.queryItems = queryItems;
    //JSON GET Request from MapQuest GeoCode API
    NSData *json = [NSData dataWithContentsOfURL:geocodeURL.URL];
    //Checking if there is valid data
    if(json.length > 0)
    {
        NSMutableDictionary *geocodeData = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:&geocodeError];
        //Setting  workLatitude/workLongitude from geocoded workLocation
        NSNumber *geocodedLatitude = [[[[[[geocodeData
                                           objectForKey:@"results"]
                                          objectAtIndex:0]
                                         objectForKey:@"locations"]
                                        objectAtIndex:0]
                                       objectForKey:@"latLng"]
                                      objectForKey:@"lat"];
        NSNumber *geocodedLongitude= [[[[[[geocodeData
                                           objectForKey:@"results"]
                                          objectAtIndex:0]
                                         objectForKey:@"locations"]
                                        objectAtIndex:0]
                                       objectForKey:@"latLng"]
                                      objectForKey:@"lng"];
        workLatitude = [geocodedLatitude doubleValue];
        workLongitude = [geocodedLongitude doubleValue];
        NSLog(@"%@ geocoded workLocation; Latitude: %0.6f, Longitude: %0.6f",self, workLatitude, workLongitude);
    }
    else
    {
        NSLog(@"GeocodeFetch was unable to fetch data");
    }
}
//Checks user input for ambiguity and returns all possible results
//Note that the first object in the return array will be an boolean value
-(NSArray *)checkWorkLocation
{
    NSError *geocodeError;
    //Generating URL for API Call
    NSURLComponents *geocodeURL = [[NSURLComponents alloc]init];
    geocodeURL.scheme = @"http";
    geocodeURL.host = @"www.mapquestapi.com";
    geocodeURL.path = @"/geocoding/v1/address";
    NSDictionary *queryParameters = @{@"key": mapquestAPIKey, @"location": workAddress};
    NSMutableArray *queryItems = [NSMutableArray array];
    for(NSString *key in queryParameters) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryParameters[key]]];
    }
    geocodeURL.queryItems = queryItems;
    //JSON GET Request from MapQuest GeoCode API
    NSData *json = [NSData dataWithContentsOfURL:geocodeURL.URL];
    NSMutableDictionary *geocodeData = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:&geocodeError];
    NSInteger countOfLocations = [[[[geocodeData
                                     objectForKey:@"results" ]
                                    objectAtIndex:0]
                                   objectForKey:@"locations"]
                                  count];
    NSMutableArray *possibleLocations = [[NSMutableArray alloc]init];
    if(countOfLocations > 1) {
        BOOL multipleLocations = true;
        [possibleLocations addObject:[NSNumber numberWithBool:multipleLocations]];
    }
    else {
        BOOL multipleLocations = false;
        [possibleLocations addObject:[NSNumber numberWithBool:multipleLocations]];
    }
    
    for(int i = 0; i < countOfLocations; i++) {
        NSString *city = [NSString stringWithFormat:@"%@",
                          [[[[[geocodeData
                                objectForKey:@"results"]
                                objectAtIndex:0]
                                objectForKey:@"locations"]
                                objectAtIndex:i]
                                objectForKey:@"adminArea5"]];
        NSString *state =[NSString stringWithFormat:@"%@",
                          [[[[[geocodeData
                                objectForKey:@"results"]
                                objectAtIndex:0]
                                objectForKey:@"locations"]
                                objectAtIndex:i]
                                objectForKey:@"adminArea3"]];
        NSString *possibleAddress = [NSString stringWithFormat:@"%@, %@, %@",workAddress,city,state];
        [possibleLocations addObject:possibleAddress];
    }
    return possibleLocations;
}
//Calculate Distance between Coordinates
-(double) distanceBetweenCoordinates {
    const int radius = 6371e3;
    double greatCircleDistance,radianCurrentLatitude, radianWorkLatitude, deltaLatitude,deltaLongitude, a, c = 0;
    //Converting degrees to radians
    radianCurrentLatitude = (currentLatitude * M_PI)/180;
    radianWorkLatitude = (workLatitude * M_PI)/180;
    deltaLatitude = ((workLatitude - currentLatitude) * M_PI)/180;
    deltaLongitude = ((workLongitude - currentLongitude) * M_PI)/180;
    //Haversine calculation
    a = (sin(deltaLatitude/2)*sin(deltaLatitude/2))+cos(radianCurrentLatitude)*cos(radianWorkLatitude)*(sin(deltaLongitude/2)*sin(deltaLongitude/2));
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    //Distance calculations
    greatCircleDistance = radius * c;
    return greatCircleDistance;
}
@end
