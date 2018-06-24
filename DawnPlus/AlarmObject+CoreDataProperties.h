//
//  AlarmObject+CoreDataProperties.h
//  
//
//  Created by Xinke Chen on 2018-06-24.
//
//

#import "AlarmObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AlarmObject (CoreDataProperties)

+ (NSFetchRequest<AlarmObject *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *alarmTime;
@property (nonatomic) BOOL appTones;
@property (nullable, nonatomic, retain) NSArray *dayToRepeat;
@property (nonatomic) BOOL enabled;
@property (nullable, nonatomic, copy) NSString *label;
@property (nullable, nonatomic, retain) NSArray *notificationIDs;
@property (nullable, nonatomic, copy) NSString *soundAsset;

@end

NS_ASSUME_NONNULL_END
