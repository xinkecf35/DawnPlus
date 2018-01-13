//
//  TrafficFetch.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 6/25/16.
//  Copyright © 20f16 Xinke Chen. All rights reserved.
//

#import "TrafficFetch.h"
#import "constants.m"

@interface TrafficFetch ()

@property (readwrite) NSMutableDictionary *trafficData;
@property (readwrite) NSInteger status;
-(NSDictionary *) intersectionsForIncident:(NSDictionary *)incident;

@end

@implementation TrafficFetch
@synthesize workLocation,trafficIncidents, coordinates, status, userDefaults, trafficData;

-(id)init {
    self = [super init];
    if(self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}
-(NSURLSessionTask *)sendTrafficRequest {
    NSURL *requestURL = [self generateURL:userDefaults];
    NSURLSessionDataTask *requestTask = [session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            status = httpResponse.statusCode;
            if([response isKindOfClass:[NSHTTPURLResponse class]]) {
                [self willChangeValueForKey:@"trafficData"];
                NSError *JSONError;
                trafficData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
                if (JSONError) {
                    NSLog(@"JSON serialization screwed up for some reason");
                } else {
                    NSLog(@"Success on serialization, status: %ld", (long)status);
                    [self didChangeValueForKey:@"trafficData"];
                }
            } else {
                NSLog(@"Request failed, following HTTP status code: %ld(long)", (long)status);
            }
        } else {
            NSLog(@"Error on data task for TrafficFetch %@",error);
        }
    }];
    [requestTask resume];
    return requestTask;
}
//Need to write documentation on how this works

-(NSInteger) addTrafficIncidents {
    if(trafficData == nil) {
        return  -1;
    }
    if([trafficData objectForKey:@"tm"] != nil) {
        NSDictionary *data = [trafficData objectForKey:@"tm"];
        NSArray *rawItems = [NSArray arrayWithArray:[data objectForKey:@"poi"]];
        NSMutableArray *filteredItems = [[NSMutableArray alloc] init];
        //Enumerating through incidents
        for (NSDictionary *item in rawItems) {
            NSMutableDictionary *incident = [[NSMutableDictionary alloc] init];
            //Setting clusteredIncidents
            if([[item objectForKey:@"cs"] intValue] == 0) {
                [incident setObject:[item objectForKey:@"d"] forKey:@"detail"];
                [incident setObject:@[] forKey:@"clusteredIncidents"];
                //[incident setObject:[self intersectionsForIncident:item] forKey:@"intersections"];
            } else {
                NSMutableArray *detailIncidents = [[NSMutableArray alloc] init];
                for (NSDictionary *detailItem in [item objectForKey:@"cpoi"]) {
                    NSMutableDictionary *detailIncident = [[NSMutableDictionary alloc] init];
                    [detailIncident setObject:[detailItem objectForKey:@"ic"] forKey:@"type"];
                    [detailIncident setObject:[detailItem objectForKey:@"d"] forKey:@"detail"];
                    [detailIncident setObject:[detailItem objectForKey:@"ty"] forKey:@"criticality"];
                    [detailIncident setObject:[detailItem objectForKey:@"p"] forKey:@"location"];
                    //[detailIncident setObject:[self intersectionsForIncident:detailItem] forKey:@"intersections"];
                    [detailIncidents addObject:detailIncident];
                }
                [incident setObject:@"Multiple Items" forKey:@"detail"];
                [incident setObject:[detailIncidents copy] forKey:@"clusteredIncidents"];
                [incident setObject:@{} forKey:@"intersections"];
            }
            [incident setObject:[item objectForKey:@"ic"] forKey:@"type"]; //Setting type
            [incident setObject:[item objectForKey:@"ty"] forKey:@"criticality"]; //Setting severity
            [incident setObject:[item objectForKey:@"p"] forKey:@"location"]; //Setting location
            [filteredItems addObject:incident];
        }
        trafficIncidents = [filteredItems copy];
        NSLog(@"trafficIncidents:\n %@",trafficIncidents);
        return [filteredItems count];
    } else {
        return 0;
    }
    return -1;
}
//Returns road labels of traffic incidents for non-nil dictionary of correct format
-(NSDictionary *)intersectionsForIncident:(NSDictionary *)incident {
    if(incident) {
        return @{
                 @"road" : [incident objectForKey:@"r"],
                 @"start": [incident objectForKey:@"f"],
                 @"stop" : [incident objectForKey:@"t"]
        };
    }
    return nil;
}
//Generate Severity based on greated number of certain incident type
//0 for critical, 1 for major, 2 for minor, 3 for lowImpact
-(NSInteger)rankOverallSeverity {
    if ([trafficIncidents count] > 0) {
        int criticalValue, minorValue, majorValue, lowImpactValue;
        criticalValue = minorValue = majorValue = lowImpactValue = 0;
        for (NSDictionary *incident in trafficIncidents) {
            NSDictionary *criticality = [incident objectForKey:@"criticality"];
            NSInteger criticalID = [[criticality objectForKey:@"ID"] integerValue];
            switch (criticalID) {
                case 0:
                    criticalValue++;
                    break;
                case 1:
                    majorValue++;
                    break;
                case 2:
                    minorValue++;
                    break;
                case 3:
                    lowImpactValue++;
                    break;
                default:
                    break;
            }
        }
        int criticalValues[4] ={criticalValue, majorValue, minorValue, lowImpactValue};
        int i, code, largestValue;
        i = largestValue = code = 0;
        while(i < 4) {
            if(criticalValues[i] > largestValue) {
                largestValue = criticalValues[i];
                code = i;
            }
            i++;
        }
        return code;
    }
    return -1;
}

-(NSString *)generateFilters:(NSUserDefaults *)defaults {
    NSArray *selectedOptions = [NSArray arrayWithArray:[defaults objectForKey:@"sensitivityCheckedCells"]];
    NSArray *queryOptions = [NSArray arrayWithObjects:
                             @"accident",@"congestion",
                             @"disabledvehicle,roadhazard,weather",
                             @"construction",@"masstransit",
                             @"misc,othernews,plannedevent",nil];
    NSMutableArray *neededOptions = [[NSMutableArray alloc] init];
    int index = 0;
    for (NSNumber *item in selectedOptions ) {
        if([item intValue] == 1)
        {
            [neededOptions addObject:[queryOptions objectAtIndex:index]];
        }
        index++;
    }
    NSString *finalString = [[neededOptions valueForKey:@"description"] componentsJoinedByString:@","];
    NSLog(@"returning filters: %@",finalString);
    return finalString;
}
-(NSURL *)generateURL:(NSUserDefaults *)defaults {
    NSURLComponents *trafficURL = [[NSURLComponents alloc] init];
    trafficURL.scheme = @"https";
    trafficURL.host = @"api.tomtom.com";
    //Creating awkward path according to TomTom APIs
    if(coordinates) {
        NSNumber *versionNumber = [NSNumber numberWithInt:4];
        NSString *style = @"s3";
        NSString *boundingBox = [NSString stringWithFormat:@"%0.6f,%0.6f,%0.6f,%0.6f",
                       [[coordinates objectForKey:@"upperLatitude"] doubleValue],
                       [[coordinates objectForKey:@"upperLongitude"] doubleValue],
                       [[coordinates objectForKey:@"lowerLatitude"] doubleValue],
                       [[coordinates objectForKey:@"lowerLongitude"] doubleValue]];
        NSNumber *zoom = [NSNumber numberWithInt:11];
        NSString *URLPath = [NSString stringWithFormat:@"/traffic/services/%@/incidentDetails/%@/%@/%@/-1/json",
                             versionNumber,style,boundingBox,zoom];
        trafficURL.path = URLPath;
        NSLog(@"%@",URLPath);
    } else {
        return nil;
    }
    NSDictionary *queryParameters = @{@"key":TOMTOM_KEY,
                                      @"expandCluster":@"true",
                                      @"projection":@"EPSG4326"
                                      };
    NSMutableArray *queryItems = [NSMutableArray array];
    for(NSString *key in queryParameters) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryParameters[key]]];
    }
    trafficURL.queryItems = queryItems;
    NSLog(@"URL is %@",trafficURL.URL);
    return trafficURL.URL;
}
@end
