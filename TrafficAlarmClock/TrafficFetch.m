//
//  TrafficFetch.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 6/25/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "TrafficFetch.h"
static const NSString *mapquestAPIKey = @"VHvMoKU4OTqvSQE7AfGzGniuwykvkdlY"; //Mapquest API Key

@implementation TrafficFetch
@synthesize workLocation,trafficIncidents;

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
//Calls Mapquest Traffic API to receive traffic data
-(void)sendTrafficRequest
{
    NSError *trafficError;
    
    //Generating URL for API Call
    NSURLComponents *trafficURL = [[NSURLComponents alloc]init];
    trafficURL.scheme = @"http";
    trafficURL.host = @"www.mapquestapi.com";
    trafficURL.path = @"/traffic/v2/incidents";
    NSString *boundingBox = [NSString stringWithFormat:@"%0.6f,%0.6f,%0.6f,%0.6f",workLatitude,workLongitude,currentLatitude,currentLongitude];
    NSDictionary *queryParameters= @{@"key":mapquestAPIKey,
                                    @"boundingBox":boundingBox,
                                    @"filters":@"congestion,incidents,event,construction"
                                     };
    NSMutableArray *queryItems = [NSMutableArray array];
    for(NSString *key in queryParameters)
    {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryParameters[key]]];
    }
    trafficURL.queryItems = queryItems;
    trafficJSON = [NSData dataWithContentsOfURL:trafficURL.URL];
    trafficData = [NSJSONSerialization JSONObjectWithData:trafficJSON options:kNilOptions error:&trafficError];
    NSLog(@"%@ received trafficData from %0.6f, %0.6f to %0.6f, %0.6f",self, currentLatitude,currentLongitude, workLatitude, workLongitude);
    //Checking statuscode of request, if not 0, no go
    NSNumber *statusCode = [[trafficData objectForKey:@"info"]objectForKey:@"statuscode"];
    status = [statusCode intValue];
    if( status != 0)
    {
        int error = status;
        self.trafficIncidents = nil;
        NSLog(@"Some error occured with fetching Traffic Data, most likely due to too large bounding box; error %d", error);
    }
}
//Adds incidents to property NSArray trafficIncidents
-(void) addTrafficIncidents
{
    //Note: May need to write code for non-zero status code
    if(status == 0)
    {
        NSArray *rawIncidentsArray = [trafficData objectForKey:@"incidents"];
        NSMutableArray *incidentsArray = [[NSMutableArray alloc]initWithCapacity:[rawIncidentsArray count]];
        if ([rawIncidentsArray count] < 1)
        {
            [incidentsArray addObject:@"0"];
            NSLog(@"%@ no major traffic incidents",self);
        }
        else
        {
            for (int i = 0; i < [rawIncidentsArray count];i++)
            {
                NSDictionary *rawIncident = [rawIncidentsArray objectAtIndex:i];
                NSDictionary *incident = @{
                                           @"severity":[rawIncident objectForKey:@"severity"],
                                           @"type":[rawIncident objectForKey:@"type"],
                                           @"fullDescription": [rawIncident objectForKey:@"fullDesc"],
                                           @"shortDescription": [rawIncident objectForKey:@"shortDesc"],
                                           @"direction": [[rawIncident objectForKey:@"parameterizedDescription" ] objectForKey:@"direction"]
                                           };
                [incidentsArray addObject:incident];
            }
        }
        self.trafficIncidents = incidentsArray;
        NSLog(@"%@ addTrafficIncidents successful with %lu incidents",self,[rawIncidentsArray count]);
        
    }
    
}
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
    NSDictionary *queryParameters = @{@"key": mapquestAPIKey, @"location": self.workLocation};
    NSMutableArray *queryItems = [NSMutableArray array];
    for(NSString *key in queryParameters)
    {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryParameters[key]]];
    }
    geocodeURL.queryItems = queryItems;
    //JSON GET Request from MapQuest GeoCode API
    NSData *json = [NSData dataWithContentsOfURL:geocodeURL.URL];
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
//Checks user input for ambiguity and returns all possible results
//Note that the first object in the return array will be an boolean value
-(NSArray *)checkWorkLocation:(NSString *)userInput
{
    NSError *geocodeError;
    //Generating URL for API Call
    NSURLComponents *geocodeURL = [[NSURLComponents alloc]init];
    geocodeURL.scheme = @"http";
    geocodeURL.host = @"www.mapquestapi.com";
    geocodeURL.path = @"/geocoding/v1/address";
    NSDictionary *queryParameters = @{@"key": mapquestAPIKey, @"location": userInput};
    NSMutableArray *queryItems = [NSMutableArray array];
    for(NSString *key in queryParameters)
    {
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
    if(countOfLocations > 1)
    {
        BOOL multipleLocations = true;
        [possibleLocations addObject:[NSNumber numberWithBool:multipleLocations]];
    }
    else
    {
        BOOL multipleLocations = false;
        [possibleLocations addObject:[NSNumber numberWithBool:multipleLocations]];
    }
    
    for(int i = 0; i < countOfLocations; i++)
    {
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
        NSString *possibleAddress = [NSString stringWithFormat:@"%@, %@, %@",userInput,city,state];
        [possibleLocations addObject:possibleAddress];
    }
    return possibleLocations;
}

@end