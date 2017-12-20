//
//  ToneTableViewController.h
//  DawnPlus
//
//  Created by Xinke Chen on 2017-07-30.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmDataDelegate.h"

@interface ToneTableViewController : UITableViewController {
    NSArray *keys;
    NSDictionary *tonesList;
}

@property (strong, nonatomic) NSString *previousSelection;
@property (weak, nonatomic) id <AlarmDataDelegate> alarmDelegate;

@end
