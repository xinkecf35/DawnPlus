//
//  ViewController.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/23/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (weak,nonatomic) IBOutlet UILabel *clockLabel;



-(void)updateClockLabel;

@end

