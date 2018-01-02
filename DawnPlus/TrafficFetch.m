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

-(NSInteger) addTrafficIncidents {
    if(trafficData == nil) {
        return  -1;
    }
    if([trafficData objectForKey:@"TRAFFIC_ITEMS"] != nil) {
        NSDictionary *data = [trafficData objectForKey:@"TRAFFIC_ITEMS"];
        NSArray *rawItems = [NSArray arrayWithArray:[data objectForKey:@"TRAFFIC_ITEM"]];
        NSMutableArray *filteredItems = [[NSMutableArray alloc] init];
        for (NSDictionary *item in rawItems) {
            NSMutableDictionary *incident = [[NSMutableDictionary alloc] init];
            [incident setObject:[item objectForKey:@"TRAFFIC_ITEM_TYPE_DESC"] forKey:@"type"];
            [incident setObject:[item objectForKey:@"CRITICALITY"] forKey:@"criticality"];
            [incident setObject:[[[item objectForKey:@"LOCATION"] objectForKey:@"GEOLOC"] objectForKey:@"ORIGIN"] forKey:@"location"];
            [incident setObject:[item objectForKey:@"TRAFFIC_ITEM_DESCRIPTION"] forKey:@"descriptions"];
            [incident setObject:[item objectForKey:@"TRAFFIC_ITEM_DETAIL"] forKey:@"detail"];
            //NSLog(@"%@ added incident %@",self, incident);
            [filteredItems addObject:incident];
        }
        trafficIncidents = [filteredItems copy];
        return [filteredItems count];
    } else {
        return 0;
    }
    return -1;
}
//Generate Severity based on greated number of certain incident type
//0 for critical, 1 for major, 2 for minor, 3 for lowImpat
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
    trafficURL.host = @"traffic.cit.api.here.com";
    trafficURL.path = @"/traffic/6.2/incidents.json";
    NSString *type = [NSString  stringWithString:[self generateFilters:defaults]];
    NSString *boundingBox = nil;
    if(coordinates) {
        boundingBox = [NSString stringWithFormat:@"%0.6f,%0.6f;%0.6f,%0.6f",
                       [[coordinates objectForKey:@"upperLatitude"] doubleValue],
                       [[coordinates objectForKey:@"upperLongitude"] doubleValue],
                       [[coordinates objectForKey:@"lowerLatitude"] doubleValue],
                       [[coordinates objectForKey:@"lowerLongitude"] doubleValue]];
    } else {
        return nil;
    }
    NSDictionary *queryParameters = @{@"bbox":boundingBox,
                                      @"app_id":HERE_APP_ID,
                                      @"app_code":HERE_APP_CODE,
                                      @"type":type};
    NSMutableArray *queryItems = [NSMutableArray array];
    for(NSString *key in queryParameters) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryParameters[key]]];
    }
    trafficURL.queryItems = queryItems;
    NSLog(@"URL is %@",trafficURL.URL);
    return trafficURL.URL;
}
@end
