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
@synthesize workLocation,trafficIncidents,workLatitude,workLongitude;

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
    //Setting Bounding Box
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
    //If status code is non-zero
    else
    {
        self.trafficIncidents = nil;
        NSLog(@"%@", self.trafficIncidents);
    }
    
}
@end
