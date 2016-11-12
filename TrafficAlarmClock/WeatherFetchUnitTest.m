//
//  WeatherFetchUnitTest.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 11/11/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherFetch.h"

@interface WeatherFetchUnitTest : XCTestCase
@property WeatherFetch *weatherTest;
@end

@implementation WeatherFetchUnitTest

- (void)setUp {
    [super setUp];
    
    self.weatherTest = [[WeatherFetch alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
