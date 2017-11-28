//
//  AlarmCreateViewController.m
//  DawnPlus
//
//  Created by Xinke Chen on 2017-10-01.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "AlarmCreateViewController.h"

@interface AlarmCreateViewController ()

@property (strong,nonatomic) UIDatePicker *timePicker;
@property (strong, nonatomic) NSArray *daysToRepeat;
@property (strong, nonatomic) AddAlarmTableViewController *tableOptionsVC;

@end

@implementation AlarmCreateViewController

@synthesize timePicker, daysToRepeat, tableOptionsVC, selectedDays, selectedTime, soundAsset, enabled, notificationID, alarmName;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTimePickerView];
    [self initAlarmTableOptionsView];
    [self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) initTimePickerView {
    timePicker = [[UIDatePicker alloc] init];
    timePicker.datePickerMode = UIDatePickerModeTime;
    [timePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    //Adding timePicker to view
    [self.view addSubview:timePicker];
    if (@available(iOS 11, *)) {
        UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
        [timePicker.centerXAnchor constraintLessThanOrEqualToAnchor:safeArea.centerXAnchor].active = YES;
        [timePicker.topAnchor constraintGreaterThanOrEqualToAnchor:safeArea.topAnchor constant:25.0].active = YES;
        [timePicker.widthAnchor constraintLessThanOrEqualToAnchor:safeArea.widthAnchor];
    } else {
        [timePicker.centerXAnchor constraintEqualToAnchor: self.view.centerXAnchor].active = YES;
        [timePicker.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:25.0].active = YES;
    }
    [timePicker setNeedsLayout];
    NSLog(@"timePicker subview complete");
}
-(void) initAlarmTableOptionsView {
    UIStoryboard *alarmViews = [UIStoryboard storyboardWithName:@"AlarmViews" bundle:nil];
    tableOptionsVC = [alarmViews instantiateViewControllerWithIdentifier:@"AlarmEditTableVIew"];
    [tableOptionsVC.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController:tableOptionsVC];
    [tableOptionsVC didMoveToParentViewController:self];
    [self.view addSubview:tableOptionsVC.tableView];
    UIView *embeddedTableView = tableOptionsVC.tableView;
    [embeddedTableView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [embeddedTableView.topAnchor constraintEqualToAnchor:timePicker.bottomAnchor constant:10].active = YES;
    [embeddedTableView.heightAnchor constraintEqualToConstant:132].active = YES;
    [embeddedTableView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [embeddedTableView setNeedsLayout];
    NSLog(@"alarmTableView subview complete");
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
