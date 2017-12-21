//
//  AlarmObject+CoreDataProperties.m
//  
//
//  Created by Xinke Chen on 2017-12-21.
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
@dynamic appTones;

@end
