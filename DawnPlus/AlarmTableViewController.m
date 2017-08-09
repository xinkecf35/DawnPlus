//
//  AlarmTableViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-05-17.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "AlarmTableViewController.h"

@implementation AlarmTableViewController

@synthesize alarmTableView,coreDataManager;

-(void)viewDidLoad {
    [self initializeAlarmResultsController];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:true];
    [coreDataManager save];
}

-(void)initializeAlarmResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AlarmObject"];
    NSSortDescriptor *labelSort = [NSSortDescriptor sortDescriptorWithKey:@"label" ascending:YES];
    request.sortDescriptors = @[labelSort];
    self.alarmResultsController = [[NSFetchedResultsController alloc]
                                   initWithFetchRequest:request
                                   managedObjectContext:coreDataManager.managedObjectContext
                                   sectionNameKeyPath:nil
                                   cacheName:nil];
    self.alarmResultsController.delegate = self;
    NSError *fetchError = nil;
    if(![[self alarmResultsController] performFetch:&fetchError]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [fetchError localizedDescription], [fetchError userInfo]);
        abort();
    }
}

//TableDataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return [[[self alarmResultsController] sections] count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self alarmResultsController] sections][section];
    return [sectionInfo numberOfObjects];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alarmCell" forIndexPath:indexPath];
    AlarmObject *alarm = [self.alarmResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = alarm.label;
    NSDateFormatter *time = [[NSDateFormatter alloc] init];
    time.dateStyle = NSDateFormatterNoStyle;
    time.timeStyle = NSDateFormatterShortStyle;
    cell.detailTextLabel.text = [time stringFromDate:alarm.alarmTime];
    //MGSwipeTableCell Setup
    cell.delegate = self;
    UIColor *deleteColor = [UIColor colorWithHue:0.0 saturation:0.85 brightness:0.86 alpha:1.0];
    MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:deleteColor];
    UIColor *editColor = [UIColor colorWithHue:0.142 saturation:0.94 brightness:0.89 alpha:1.0];
    MGSwipeButton *editButton = [MGSwipeButton buttonWithTitle:@"Edit" backgroundColor:editColor];
    cell.rightButtons = @[editButton,deleteButton];
    cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"AddAlarmSegue"]) {
        AddAlarmViewController *addAlarmVC = segue.destinationViewController;
        addAlarmVC.coreDataManager = self.coreDataManager;
    }
}
//NSFetchResultsControllerDelegates
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
@end
