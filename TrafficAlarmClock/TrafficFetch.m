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

+(TrafficFetch *)sharedTraffic
{
    static TrafficFetch *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]initWithLocation: [LocationFetch sharedInstance].currentLocation.coordinate.latitude : [LocationFetch sharedInstance].currentLocation.coordinate.latitude];
    });
    return instance;
}

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
                                    @"filters":@"congestion,incidents,event"
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
}
-(NSDictionary*) addTrafficIncidents
{
    NSArray *rawIncidentsArray = [trafficData objectForKey:@"incidents"];
    NSMutableDictionary *simpifiedIncidents = [[NSMutableDictionary alloc]init];
    for (*item in rawIncidentsArray)
    {
        
    }
    
}


@end