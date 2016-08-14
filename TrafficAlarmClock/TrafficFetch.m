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
//
/*
+(TrafficFetch *)sharedTraffic
{
    static TrafficFetch *instance;
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
    //JSON GET Request from MapQuest GeoCode API
    NSData *json = [NSData dataWithContentsOfURL:trafficURL.URL];
    NSMutableDictionary *geocodeData = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:&trafficError];
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


-(void)sendTrafficRequest
{
    NSError *trafficError;
    
    //Getting Traffic Information
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
    //NSLog(@"%@",trafficData);
    NSLog(@"%@ received trafficData from %0.6f, %0.6f to %0.6f, %0.6f",self, currentLatitude,currentLongitude, workLatitude, workLongitude);
    //Checking statuscode of request, if not 0, no go
    NSNumber *statusCode = [[trafficData objectForKey:@"info"]objectForKey:@"statuscode"];
    //NSLog(@"%@",statusCode);
    status = [statusCode intValue];
    if( status != 0)
    {
        NSArray *error = @[@"-1",[NSNumber numberWithInt:status]];
        self.trafficIncidents = error;
        NSLog(@"Some error occured with fetching Traffic Data, most likely due to too large bounding box");
    }
}
-(void) addTrafficIncidents
{
    if(status == 0)
    {
        NSArray *rawIncidentsArray = [trafficData objectForKey:@"incidents"];
        NSMutableArray *incidentsArray = [[NSMutableArray alloc]initWithCapacity:[rawIncidentsArray count]];
        //NSLog(@"%lu",(unsigned long)[rawIncidentsArray count]);
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


@end