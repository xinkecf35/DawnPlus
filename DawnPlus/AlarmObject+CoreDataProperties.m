//
//  AlarmObject+CoreDataProperties.m
//  DawnPlus
//
//  Created by Xinke Chen on 2017-08-31.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//
//

#import "AlarmObject+CoreDataProperties.h"

@implementation AlarmObject (CoreDataProperties)

+ (NSFetchRequest<AlarmObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AlarmObject"];
}

@dynamic alarmTime;
@dynamic dayToRepeat;
@dynamic enabled;
@dynamic label;
@dynamic notificationID;
@dynamic soundAsset;

@end
