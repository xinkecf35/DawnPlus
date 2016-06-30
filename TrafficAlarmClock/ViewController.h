//
//  ViewController.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/23/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationFetch.h"
#import "WeatherFetch.h"
#import "TrafficFetch.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property double latitude;
@property double longitude;
@property (weak,nonatomic) IBOutlet UILabel *clockLabel;


-(void)updateClockLabel;

@end

