//
//  DetailViewController.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/6/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

