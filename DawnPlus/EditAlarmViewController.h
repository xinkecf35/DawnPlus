//
//  EditAlarmViewController.h
//  DawnPlus
//
//  Created by Xinke Chen on 2017-09-04.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CoreDataController.h"
#import "AlarmObject+CoreDataClass.h"
#import "AlarmDataDelegate.h"

#import "AddAlarmTableViewController.h"

@interface EditAlarmViewController : UIViewController <AlarmDataDelegate, UITableViewDelegate> {
    AddAlarmTableViewController *embeddedVC;
}

@end
