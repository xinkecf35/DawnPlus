//
//  Alarm+CoreDataProperties.m
//  DawnPlus
//
//  Created by Xinke Chen on 2017-08-05.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//
//

#import "Alarm+CoreDataProperties.h"

@implementation Alarm (CoreDataProperties)

+ (NSFetchRequest<Alarm *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Alarm"];
}

@dynamic alarmTime;
@dynamic dayToRepeat;
@dynamic enabled;
@dynamic notificationID;
@dynamic soundAsset;

@end
