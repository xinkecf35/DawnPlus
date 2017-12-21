//
//  AlarmObject+CoreDataProperties.h
//  
//
//  Created by Xinke Chen on 2017-12-21.
//
//

#import "AlarmObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AlarmObject (CoreDataProperties)

+ (NSFetchRequest<AlarmObject *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *alarmTime;
@property (nullable, nonatomic, retain) NSArray *dayToRepeat;
@property (nonatomic) BOOL enabled;
@property (nullable, nonatomic, copy) NSString *label;
@property (nullable, nonatomic, copy) NSString *notificationID;
@property (nullable, nonatomic, copy) NSString *soundAsset;
@property (nonatomic) BOOL appTones;

@end

NS_ASSUME_NONNULL_END
