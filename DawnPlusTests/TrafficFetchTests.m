//
//  TrafficFetchTests.m
//  DawnPlusTests
//
//  Created by Xinke Chen on 2017-08-13.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TrafficFetch.h"
#import <OCMock/OCMock.h>

@interface TrafficFetchTests : XCTestCase

@property (strong,nonatomic) TrafficFetch *trafficTest;
@property (strong, nonatomic) NSUserDefaults *mockUserDefaults;

@end

@implementation TrafficFetchTests

static const NSString *sensitivityKey = @"sensitivityCheckedCells";

@synthesize trafficTest,mockUserDefaults;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    trafficTest = [[TrafficFetch alloc] init];
    mockUserDefaults = [[NSUserDefaults alloc] init];
    NSArray *mockSettings = [NSArray arrayWithObjects:
                             [NSNumber numberWithInt:1],[NSNumber numberWithInt:1],
                             [NSNumber numberWithInt:1],[NSNumber numberWithInt:1],
                             [NSNumber numberWithInt:1],[NSNumber numberWithInt:1], nil];

    [mockUserDefaults setObject:mockSettings forKey:sensitivityKey];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    trafficTest = nil;
    mockUserDefaults = nil;
    [super tearDown];
}

-(void)testURLGeneration {
    NSString *goodURLString = @"https://traffic.cit.api.here.com/traffic/6.2/incidents.json?app_code=s90vON9VRub7bojMcAC-Zg&app_id=J4k08i80f9ocJqcBmXPi&type=accident,congestion,disabledvehicle,roadhazard,weather,construction,masstransit,misc,othernews,plannedevent&bbox=39.000000,-74.000000;40.000000,-75.000000";
    NSURL *goodURL = [NSURL URLWithString:goodURLString];
    NSDictionary *mockCoordinates = @{
                                  @"lowerLatitude": [NSNumber numberWithDouble:40.0],
                                  @"lowerLongitude": [NSNumber numberWithDouble:-75.0],
                                  @"upperLatitude": [NSNumber numberWithDouble:39.0],
                                  @"upperLongitude": [NSNumber numberWithDouble:-74.0]
                                  };
    trafficTest.coordinates = mockCoordinates;
    NSLog(@"%@",[mockUserDefaults valueForKey:@"sensitivityCheckedCells"]);
    NSURL *testURL = [trafficTest generateURL:mockUserDefaults];
    XCTAssert([testURL isEqual:goodURL], @"URL generation is good");
    
}



@end
