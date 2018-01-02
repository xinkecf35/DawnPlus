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
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}
- (void)testSendWeatherFetch {
    weatherTest = nil;
    mockUserDefaults = nil;
}

@end
