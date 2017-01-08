//
//  geocodeFetch.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 10/9/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "GeocodeFetch.h"
static const NSString *mapquestAPIKey = @"VHvMoKU4OTqvSQE7AfGzGniuwykvkdlY"; //Mapquest API Key
static const int radius = 6371e3;

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
//Calculate Midpoint
-(NSDictionary *)midpointBetweenCoordinates {
    double latitudeMidpoint, longitudeMidpoint, radianCurrentLatitude, radianWorkLatitude, deltaLongitude = 0;
    //Converting to Radians
    radianCurrentLatitude = (currentLatitude * M_PI)/180;
    radianWorkLatitude = (workLatitude * M_PI)/180;
    deltaLongitude = ((workLongitude - currentLongitude) * M_PI)/180;
    double radianCurrentLongitude = (currentLongitude * M_PI)/180;
    //Calculating Midpoint
    double Bx = cos(radianWorkLatitude)*cos(deltaLongitude);
    double By = cos(radianWorkLatitude)*sin(deltaLongitude);
    double Ly = sin(radianCurrentLatitude) + sin(radianWorkLatitude);
    double Lx = sqrt(((cos(radianCurrentLatitude) + Bx)*(cos(radianCurrentLatitude) + Bx)+(By*By)));
    latitudeMidpoint = atan2(Ly, Lx);
    longitudeMidpoint = radianCurrentLongitude + atan2(By, (cos(radianCurrentLatitude)+Bx));
    //Converting back to degrees
    latitudeMidpoint = (latitudeMidpoint * 180)/M_PI;
    longitudeMidpoint = (longitudeMidpoint * 180)/M_PI;
    NSDictionary *midpointCoordinates = @{
                                          @"latitude":[NSNumber numberWithDouble:latitudeMidpoint],
                                          @"longitude":[NSNumber numberWithDouble:longitudeMidpoint]
                                          };
    return midpointCoordinates;
}
//Calculate Bounding Box Coordinates
-(NSDictionary *)boundingBoxCalculations {
    //Constants
    double circleRadius = [self distanceBetweenCoordinates]/2;
    double boxDiagonal = sqrt((circleRadius*circleRadius)+(circleRadius*circleRadius));
    double angularDistance = boxDiagonal/radius;
    NSDictionary *midpoint = [self midpointBetweenCoordinates];
    double midpointLatitude = [[midpoint objectForKey:@"latitude"] doubleValue];
    double midpointLongitude = [[midpoint objectForKey:@"longitude"] doubleValue];
    //Degree to radian conversion
    double radianLatitude = (midpointLatitude * M_PI)/180;
    double radianLongitude = (midpointLongitude * M_PI)/180;
    double upperLatitude, upperLongitude, lowerLatitude, lowerLongitude = 0;
    //Bounding box calculations
    lowerLatitude = asin(sin(radianLatitude)*cos(angularDistance)+cos(radianLatitude)*sin(angularDistance)*cos((135 * M_PI)/180));
    lowerLongitude = radianLongitude + atan2(sin((135 * M_PI)/180)*sin(angularDistance)*cos(lowerLatitude), cos(angularDistance)-sin(radianLatitude)*sin(lowerLatitude));
    upperLatitude = asin(sin(radianLatitude)*cos(angularDistance)+cos(radianLatitude)*sin(angularDistance)*cos((315 * M_PI)/180));
    upperLongitude = radianLongitude + atan2(sin((315 * M_PI)/180)*sin(angularDistance)*cos(lowerLatitude), cos(angularDistance)-sin(radianLatitude)*sin(lowerLatitude));
    //radian to degree conversion
    lowerLatitude = (lowerLatitude * 180)/M_PI;
    lowerLongitude = (lowerLongitude * 180)/M_PI;
    upperLatitude = (upperLatitude * 180)/M_PI;
    upperLongitude = (upperLongitude * 180)/M_PI;
    //Returning bounding box coordinates
    NSDictionary *boundingBox = @{
                                  @"lowerLatitude": [NSNumber numberWithDouble:lowerLatitude],
                                  @"lowerLongitude": [NSNumber numberWithDouble:lowerLongitude],
                                  @"upperLatitude": [NSNumber numberWithDouble:upperLatitude],
                                  @"upperLongitude": [NSNumber numberWithDouble:upperLongitude]
                                  };
    return boundingBox;
}
@end
