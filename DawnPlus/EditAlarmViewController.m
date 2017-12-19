//
//  EditAlarmViewController.m
//  DawnPlus
//
//  Created by Xinke Chen on 2017-12-18.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "EditAlarmViewController.h"

@interface EditAlarmViewController ()

@end

@implementation EditAlarmViewController

@synthesize selectedAlarm;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    saveButton.title = @"Done";
    saveButton.action = @selector(saveToCoreData);
    [self fetchFromCoreData];
    [self.timePicker setDate:self.selectedTime];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchFromCoreData {
    self.selectedDays = selectedAlarm.dayToRepeat;
    self.alarmName = selectedAlarm.label;
    self.soundAsset = selectedAlarm.soundAsset;
    self.selectedTime = selectedAlarm.alarmTime;
}

- (void)saveToCoreData {
    //Maybe use KVC to prevent unnesscary changes
    selectedAlarm.dayToRepeat = self.selectedDays;
    selectedAlarm.soundAsset = self.soundAsset;
    selectedAlarm.alarmTime = self.selectedTime;
    selectedAlarm.label = self.alarmName;
    NSLog(@"Alarm is now: %@",selectedAlarm);
    [self.navigationController popViewControllerAnimated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
