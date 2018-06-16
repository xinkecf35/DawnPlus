//
//  AlarmCreateViewController.m
//  DawnPlus
//
//  Created by Xinke Chen on 2017-10-01.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "AlarmCreateViewController.h"

@interface AlarmCreateViewController () 

@end

@implementation AlarmCreateViewController

@synthesize timePicker, daysToRepeat,coreDataManager, tableOptionsVC, selectedDays, selectedTime, soundAsset, enabled, notificationID, appTones, alarmName;

- (void)viewDidLoad {
    [super viewDidLoad];
    saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveToCoreData)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [self.view layoutSubviews];
}

- (void)loadView {
    [super loadView];
    [self initTimePickerView];
    [self initAlarmTableOptionsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initTimePickerView {
    timePicker = [[UIDatePicker alloc] init];
    timePicker.datePickerMode = UIDatePickerModeTime;
    [timePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    // Adding timePicker to view
    [self.view addSubview:timePicker];
    // Setting Constraints
    if (@available(iOS 11, *)) {
        UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
        [timePicker.centerXAnchor constraintLessThanOrEqualToAnchor:safeArea.centerXAnchor].active = YES;
        [timePicker.topAnchor constraintGreaterThanOrEqualToAnchor:safeArea.topAnchor constant:25.0].active = YES;
        [timePicker.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor].active = YES;
        [timePicker.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor].active = YES;
    } else {
        [timePicker.centerXAnchor constraintEqualToAnchor: self.view.centerXAnchor].active = YES;
        [timePicker.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:25.0].active = YES;
        [timePicker.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
        [timePicker.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    }
    [timePicker setNeedsLayout];
    [timePicker addTarget:self action:@selector(updateSelectedTime) forControlEvents:UIControlEventValueChanged];
    // Provide non-null default for alarm
    selectedTime = timePicker.date;
    //NSLog(@"timePicker subview complete");
}
- (void)initAlarmTableOptionsView {
    UIStoryboard *alarmViews = [UIStoryboard storyboardWithName:@"AlarmViews" bundle:nil];
    tableOptionsVC = [alarmViews instantiateViewControllerWithIdentifier:@"AlarmEditTableVIew"];
    tableOptionsVC.alarmDelegate = self;
    [tableOptionsVC.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController:tableOptionsVC];
    [tableOptionsVC didMoveToParentViewController:self];
    [self.view addSubview:tableOptionsVC.tableView];
    UIView *embeddedTableView = tableOptionsVC.tableView;
    [embeddedTableView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [embeddedTableView.topAnchor constraintEqualToAnchor:timePicker.bottomAnchor constant:10].active = YES;
    [embeddedTableView.heightAnchor constraintEqualToConstant:132].active = YES;
    if (@available(iOS 11, *)) {
        UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
        [embeddedTableView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor].active = YES;
        [embeddedTableView.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor].active = YES;
    } else {
        [embeddedTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
        [embeddedTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    }
    [embeddedTableView setNeedsLayout];
    NSLog(@"alarmTableView subview complete");
}
- (void)updateSelectedTime {
    selectedTime = timePicker.date;
}

- (void)saveToCoreData {
    AlarmObject *alarm = [NSEntityDescription insertNewObjectForEntityForName:@"AlarmObject" inManagedObjectContext:coreDataManager.managedObjectContext];
    alarm.alarmTime = selectedTime;
    alarm.soundAsset = soundAsset;
    if(appTones == nil) {
        alarm.appTones = NO;
    } else {
        alarm.appTones = [appTones boolValue];
    }
    alarm.dayToRepeat = selectedDays;
    alarm.enabled = YES;
    alarm.label = alarmName;
    alarm.notificationID = [[NSUUID UUID] UUIDString];
    NSLog(@"Alarm being saved with %@",alarm);
    NSLog(@"message saveToCoreData passed");
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
