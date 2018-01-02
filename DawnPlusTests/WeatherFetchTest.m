//
//  WeatherFetchTest.m
//  DawnPlusTests
//
//  Created by Xinke Chen on 2018-01-02.
//  Copyright © 2018 Xinke Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherFetch.h"

@interface WeatherFetchTest : XCTestCase

@property (strong, nonatomic) WeatherFetch *weatherTest;
@property (strong, nonatomic) NSUserDefaults *mockUserDefaults;

@end

@implementation WeatherFetchTest

@synthesize weatherTest, mockUserDefaults;

- (void)setUp {
    [super setUp];
    weatherTest = [[WeatherFetch alloc] init];
    mockUserDefaults = [[NSUserDefaults alloc] init];
    [mockUserDefaults setObject:[NSNumber numberWithInt:1] forKey:@"isFarenheit"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    weatherTest = nil;
    mockUserDefaults = nil;
    
}
- (void)testSendWeatherFetch {
    NSString *description = @"Get from Dark Sky REST API";
    XCTestExpectation *expectation = [self expectationWithDescription:description];
    [weatherTest setWeatherLocation:39.991752 :-75.113155];
    weatherTest.defaults = mockUserDefaults;
    XCTAssertNotNil([weatherTest sendWeatherRequest], @"Request has been created");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertNotNil(weatherTest.weatherData, @"weatherData is not nil");
        [weatherTest setWeatherParameters];
        XCTAssertNotNil(weatherTest.currentCondition, @"Correct response has been received");
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    NSLog(@"weatherData is: %@",weatherTest.weatherData);
}

@end
