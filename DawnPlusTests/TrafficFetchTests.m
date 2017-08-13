//
//  TrafficFetchTests.m
//  DawnPlusTests
//
//  Created by Xinke Chen on 2017-08-12.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TrafficFetch.h"

@interface TrafficFetchTests : XCTestCase

@property (strong, nonatomic) TrafficFetch *trafficTest;

@end

@implementation TrafficFetchTests

@synthesize trafficTest;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    trafficTest = [[TrafficFetch alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testURLGeneration {
    
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
