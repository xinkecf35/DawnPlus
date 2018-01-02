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

NSString *sensitivityKey = @"sensitivityCheckedCells";

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
    NSString *goodURLString = @"https://traffic.cit.api.here.com/traffic/6.2/incidents.json?app_code=SvmUX0d3scSSRHkCfKl_Xw&app_id=SGYkx5GuiLHKROvjPKZm&type=accident,congestion,disabledvehicle,roadhazard,weather,construction,masstransit,misc,othernews,plannedevent&bbox=39.000000,-74.000000;40.000000,-75.000000";
    NSURL *goodURL = [NSURL URLWithString:goodURLString];
    NSDictionary *mockCoordinates = @{
                                  @"lowerLatitude": [NSNumber numberWithDouble:40.000000],
                                  @"lowerLongitude": [NSNumber numberWithDouble:-75.000000],
                                  @"upperLatitude": [NSNumber numberWithDouble:39.000000],
                                  @"upperLongitude": [NSNumber numberWithDouble:-74.000000]
                                  };
    trafficTest.coordinates = mockCoordinates;
    NSURL *testURL = [trafficTest generateURL:mockUserDefaults];
    XCTAssert([testURL isEqual:goodURL], @"URL generation is good");
    
}
-(void)testSendTrafficRequest {
    NSString *description = @"Get from HERE Traffic REST API";
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    NSDictionary *mockCoordinates = @{
                                      @"lowerLatitude": [NSNumber numberWithDouble:40.0],
                                      @"lowerLongitude": [NSNumber numberWithDouble:-75.0],
                                      @"upperLatitude": [NSNumber numberWithDouble:39.0],
                                      @"upperLongitude": [NSNumber numberWithDouble:-74.0]
                                      };
    trafficTest.coordinates = mockCoordinates;
    trafficTest.userDefaults = mockUserDefaults;
    XCTAssertNotNil([trafficTest sendTrafficRequest], @"Data should be succesufully created");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertNotNil(trafficTest.trafficData, @"Data is not nil");
        XCTAssertNotNil([trafficTest.trafficData objectForKey:@"TRAFFIC_ITEMS"],@"Correct Response has been given");
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:5.0 handler:nil];

}
-(void)testAddTrafficIncidents {
    NSDictionary *mockCoordinates = @{
                                      @"lowerLatitude": [NSNumber numberWithDouble:40.0],
                                      @"lowerLongitude": [NSNumber numberWithDouble:-75.0],
                                      @"upperLatitude": [NSNumber numberWithDouble:39.0],
                                      @"upperLongitude": [NSNumber numberWithDouble:-74.0]
                                      };
    trafficTest.coordinates = mockCoordinates;
    trafficTest.userDefaults = mockUserDefaults;
    XCTAssertTrue([trafficTest addTrafficIncidents] == -1, @"Should return -1 with trafficData being nil");
    XCTestExpectation *expectation = [self expectationWithDescription:@"Adding incidents after data is available"];
    [trafficTest sendTrafficRequest];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertTrue([trafficTest addTrafficIncidents] > 0, @"Should have incidents added");
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}
-(void)testRankOverallSeverity {
    NSDictionary *criticalDict = @{@"criticality":@{@"ID":@"0",@"DESCRIPTION":@"critical"}};
    NSDictionary *majorDict = @{@"criticality":@{@"ID":@"1",@"DESCRIPTION":@"major"}};
    NSDictionary *minorDict = @{@"criticality":@{@"ID":@"2",@"DESCRIPTION":@"minor"}};
    NSDictionary *lowImpactDict = @{@"criticality":@{@"ID":@"3",@"DESCRIPTION":@"lowImpact"}};
    XCTAssertTrue([trafficTest addTrafficIncidents] == -1, @"Should return -1 with no incidents due to nil");
    NSMutableArray *mockIncidents = [[NSMutableArray alloc] init];
    trafficTest.trafficIncidents = mockIncidents;
    XCTAssertTrue([trafficTest rankOverallSeverity] == -1, @"Should return -1 with no incidents inserted");
    [mockIncidents addObject:criticalDict];
    XCTAssertTrue([trafficTest rankOverallSeverity] == 0, @"Should return 0 with critical being the largest value");
    [mockIncidents addObject:majorDict];
    XCTAssertTrue([trafficTest rankOverallSeverity] == 0, @"Should still return 0 with critical and major incidents added");
    [mockIncidents removeObject:criticalDict];
    XCTAssertTrue([trafficTest rankOverallSeverity] == 1, @"Should return 1 with major being the largest value");
    [mockIncidents addObject:minorDict];
    [mockIncidents removeObject:majorDict];
    XCTAssertTrue([trafficTest rankOverallSeverity] == 2, @"Should return 2 with minor being the largest value");
    [mockIncidents addObject:lowImpactDict];
    [mockIncidents removeObject:minorDict];
    XCTAssertTrue([trafficTest rankOverallSeverity] == 3, @"Should return 3 with lowImpact being the largest value");
    [mockIncidents removeAllObjects];
    int i = 0;
    while (i < 2) {
        [mockIncidents addObject:criticalDict];
        i++;
    }
    i = 0;
    while (i < 3) {
        [mockIncidents addObject:majorDict];
        i++;
    }
    [mockIncidents addObject:minorDict];
    [mockIncidents addObject:lowImpactDict];
    XCTAssertTrue([trafficTest rankOverallSeverity] == 1, @"Should return 2 with major having most incidents");
    
}



@end
