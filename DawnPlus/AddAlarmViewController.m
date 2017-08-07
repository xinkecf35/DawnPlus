//
//  AddAlarmViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-06-02.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "AddAlarmViewController.h"
@implementation AddAlarmViewController

@synthesize timePicker, selectedDays, alarmName, enabled, selectedTime, notificationID, soundAsset,coreDataManager;

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
    AlarmObject *alarm = [NSEntityDescription insertNewObjectForEntityForName:@"AlarmObject" inManagedObjectContext:coreDataManager.managedObjectContext];
    alarm.alarmTime = selectedTime;
    alarm.soundAsset = soundAsset;
    alarm.dayToRepeat = selectedDays;
    alarm.enabled = YES;
    alarm.label = alarmName;
    alarm.notificationID = [[NSUUID UUID] UUIDString];
    NSLog(@"Alarm being saved with %@",alarm);
    NSError *dataError = nil;
    if([coreDataManager.managedObjectContext save:&dataError] == NO) {
        NSAssert(NO, @"Error saving context %@\n%@", [dataError localizedDescription], [dataError userInfo]);
    }
    NSLog(@"message saveToCoreData passed");
    [self.navigationController popViewControllerAnimated:true];
    
}

//setting delegates for children
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"embedAlarmSegue"]) {
        embeddedVC = segue.destinationViewController;
        embeddedVC.alarmDelegate = self;
    }
}
@end


