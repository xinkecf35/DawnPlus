//
//  AddAlarmViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-06-02.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "AddAlarmViewController.h"

@implementation AddAlarmViewController

@synthesize selectedTime, dayRepeat;

-(void) viewDidLoad {
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:true];
    
}
- (IBAction)pickerTimeChanged:(id)sender forEvent:(UIEvent *)event {
    dispatch_async(dispatch_get_main_queue(), ^ {
        selectedTime = _timePicker.date;
        NSLog(@"Date Picker has changed, %@",selectedTime);
    });
}

@end
