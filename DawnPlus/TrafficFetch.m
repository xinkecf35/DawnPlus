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
// Adds NSURLSessionTask to NSURLSession to retrieve incidents from TomTom
// Returns NSURLSessionTask to verify data task is added
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
/* Filtering through TomTom JSON response and adding relevant data
 * returns -1 if response is nil
 * Contains keys: criticality, detail, intersections, location, type, clusteredIncidents
 * clusteredIncidents may be empty if response from TomTom is cluster type
 * incidents in clusdteredIncidents contains all the above keys excluding clusteredIncidents
 */
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
                [incident setObject:[self intersectionsForIncident:item] forKey:@"intersections"];
            } else {
                NSMutableArray *detailIncidents = [[NSMutableArray alloc] init];
                for (NSDictionary *detailItem in [item objectForKey:@"cpoi"]) {
                    NSMutableDictionary *detailIncident = [[NSMutableDictionary alloc] init];
                    [detailIncident setObject:[detailItem objectForKey:@"ic"] forKey:@"type"];
                    [detailIncident setObject:[detailItem objectForKey:@"d"] forKey:@"detail"];
                    [detailIncident setObject:[detailItem objectForKey:@"ty"] forKey:@"criticality"];
                    [detailIncident setObject:[detailItem objectForKey:@"p"] forKey:@"location"];
                    [detailIncident setObject:[self intersectionsForIncident:detailItem] forKey:@"intersections"];
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
        NSMutableDictionary *intersection = [[NSMutableDictionary alloc] init];
        if([incident objectForKey:@"f"]) {
            [intersection setObject:[incident objectForKey:@"f"] forKey:@"start"];
            [intersection setObject:[incident objectForKey:@"t"] forKey:@"stop"];
        }
        if([incident objectForKey:@"r"]) {
            [intersection setObject:[incident objectForKey:@"r"] forKey:@"road"];
        }
        return [intersection copy];
    }
    return @{};
}
/* Generate Severity based on greated number of certain incident type
 * 0 for unknown, 1 for minor, 2 for moderate, 3 for major and undefined (critical)
 * Refer to TomTom Traffic incident response for more info
 */
-(NSInteger)rankOverallSeverity {
    if ([trafficIncidents count] > 0) {
        int criticalValue, minorValue, moderateValue, unknownValue;
        criticalValue = minorValue = moderateValue = unknownValue = 0;
        for (NSDictionary *incident in trafficIncidents) {
            NSInteger criticalID = [[incident objectForKey:@"criticality"] integerValue];
            switch (criticalID) {
                case 0:
                    unknownValue++;
                    break;
                case 1:
                    minorValue++;
                    break;
                case 2:
                    moderateValue++;
                    break;
                case 3:
                    criticalValue++;
                    break;
                case 4:
                    criticalValue++;
                    break;
                default:
                    break;
            }
        }
        //identifying largest value and returning index as code
        int values[4] = {unknownValue, minorValue, moderateValue, criticalValue};
        int code, largestValue;
        largestValue = code = 0;
        for (int i = 0; i < 4; i++) {
            if (values[i] >= largestValue) {
                largestValue = values[i];
                code = i;
            }
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
