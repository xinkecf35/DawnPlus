//
//  AlarmObject+CoreDataClass.m
//  DawnPlus
//
//  Created by Xinke Chen on 2017-08-05.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//
//

#import "AlarmObject+CoreDataClass.h"

@implementation AlarmObject

- (NSArray *)generateNotificationIDs {
    NSUInteger capacity = 7;
    NSMutableArray<NSString *> *array = [NSMutableArray arrayWithCapacity:capacity];
    for(int i = 0; i < capacity; i++) {
        [array addObject:[[NSUUID UUID] UUIDString]];
    }
    return array;
}

@end
