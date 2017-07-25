//
//  LabelViewController.h
//  DawnPlus
//
//  Created by Xinke Chen on 2017-07-25.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmDataDelegate.h"

@interface LabelViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *labelTextField;
@property (weak, nonatomic) id <AlarmDataDelegate> delegate;

@end
