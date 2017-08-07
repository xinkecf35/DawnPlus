//
//  LabelViewController.m
//  DawnPlus
//
//  Created by Xinke Chen on 2017-07-25.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "LabelViewController.h"

@implementation LabelViewController

@synthesize labelTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *day = [[NSDateFormatter alloc] init];
    day.dateFormat = @"EEEE";
    NSString *dayLabel = [NSString stringWithFormat:@"My %@ Alarm", [day stringFromDate:date]];
    labelTextField.placeholder = dayLabel;
}

- (IBAction)labelTextField:(id)sender {
}
@end
