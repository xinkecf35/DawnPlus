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

@end