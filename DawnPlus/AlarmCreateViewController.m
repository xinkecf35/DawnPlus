//
//  AlarmCreateViewController.m
//  
//
//  Created by Xinke Chen on 2017-09-17.
//

#import "AlarmCreateViewController.h"
#import "AddAlarmTableViewController.h"
#import "ToneTableViewController.h"
#import "DayTableViewController.h"
#import "LabelViewController.h"

@interface AlarmCreateViewController ()

@property (strong, nonatomic) AddAlarmTableViewController *optionsVC;
@property (strong, nonatomic) UIDatePicker *timePicker;

@end

@implementation AlarmCreateViewController

@synthesize alarmName, selectedDays, selectedTime, notificationID, soundAsset, enabled, timePicker, optionsVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addDatePickerView {
    CGRect frame = CGRectMake(0, 64, self.view.frame.size.width, 200);
    self.timePicker = [[UIDatePicker alloc] initWithFrame:frame];
    timePicker.datePickerMode = UIDatePickerModeTime;
}

-(void)addTableView {
    
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
