//
//  AddAlarmViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-06-02.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "AddAlarmViewController.h"

@implementation AddAlarmViewController

@synthesize timePicker, selectedDays, alarmName, enabled, selectedTime, notificationID;

-(void) viewDidLoad {
    UIBarButtonItem *saveDone = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveToCoreData)];
    self.navigationItem.rightBarButtonItem = saveDone;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:true];
    
}
- (IBAction)pickerTimeChanged:(id)sender forEvent:(UIEvent *)event {
    dispatch_async(dispatch_get_main_queue(), ^ {
        selectedTime = timePicker.date;
        NSLog(@"Date Picker has changed, %@", timePicker.date);
    });
}

-(void)saveToCoreData {
    NSLog(@"message saveToCoreData passed");
    
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

//setting delegates for children
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"repeatSegue"]) {
        DayTableViewController *daysViewController = segue.destinationViewController;
        daysViewController.delegate = self;
    }

}
@end
