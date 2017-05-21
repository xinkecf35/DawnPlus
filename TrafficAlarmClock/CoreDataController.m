//
//  CoreDataController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-05-21.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "CoreDataController.h" 

@interface CoreDataController()

@property (strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (strong) NSManagedObjectContext *privateContext;
@property (copy) CallbackBlock callback;

-(void)initializeCoreData;
@end

@implementation CoreDataController

-(id)initWithCallback:(CallbackBlock)callback; {
    self = [super init];
    if(!self) return nil;
    [self setCallback:callback];
    [self initializeCoreData];
    return self;
}

-(void)initializeCoreData {
    if([self managedObjectContext]) return;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom, @"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
}

@end

