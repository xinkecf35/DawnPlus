//
//  Alarm+CoreDataProperties.h
//  DawnPlus
//
//  Created by Xinke Chen on 2017-08-05.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//
//

#import "Alarm+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Alarm (CoreDataProperties)

+ (NSFetchRequest<Alarm *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *alarmTime;
@property (nullable, nonatomic, retain) NSObject *dayToRepeat;
@property (nonatomic) BOOL enabled;
@property (nonatomic) int16_t notificationID;
@property (nullable, nonatomic, copy) NSString *soundAsset;

@end

NS_ASSUME_NONNULL_END
