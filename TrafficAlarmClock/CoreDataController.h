//
//  CoreDataManager.h
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-05-21.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^CallbackBlock)(void);

@interface CoreDataController : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

-(id)initWithCallback:(CallbackBlock)callback;
-(void)save;

@end
