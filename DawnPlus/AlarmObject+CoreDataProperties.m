//
//  AlarmObject+CoreDataProperties.m
//  
//
//  Created by Xinke Chen on 2018-06-24.
//
//

#import "AlarmObject+CoreDataProperties.h"

@implementation AlarmObject (CoreDataProperties)

+ (NSFetchRequest<AlarmObject *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"AlarmObject"];
}

@dynamic alarmTime;
@dynamic appTones;
@dynamic dayToRepeat;
@dynamic enabled;
@dynamic label;
@dynamic notificationIDs;
@dynamic soundAsset;

@end
