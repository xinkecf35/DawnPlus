//
//  ViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/23/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize clockLabel, testLocation, currentLatitude,currentLongitude, currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateClockLabel];
    

    
}

-(void)viewDidAppear:(BOOL)animated {
    [self updateTestLocation: self.currentLongitude : self.currentLatitude];
    WeatherFetch *weatherManager = [[WeatherFetch alloc]initWithLocation:currentLongitude :currentLatitude];
    [weatherManager sendWeatherRequest];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) updateClockLabel {
    NSDateFormatter *clockFormat= [[NSDateFormatter alloc] init];
    [clockFormat setDateFormat:@"hh:mm a"];
    self.clockLabel.text = [clockFormat stringFromDate:[NSDate date]];
    [self performSelector:@selector(updateClockLabel) withObject:self afterDelay:1.0];
}
-(void)updateTestLocation : (double) longitude : (double) latitude {
    
    self.testLocation.text = [NSString stringWithFormat:@"%.6f",longitude];
    
}

@end
