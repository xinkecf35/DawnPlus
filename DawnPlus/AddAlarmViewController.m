//
//  AddAlarmViewController.m
//  DawnPlus
//
//  Created by Xinke Chen on 2017-11-28.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "AddAlarmViewController.h"

@interface AddAlarmViewController ()

@end

@implementation AddAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    super.tableOptionsVC.alarmDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
