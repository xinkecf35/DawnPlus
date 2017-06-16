//
//  AddAlarmViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 2017-06-02.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "AddAlarmViewController.h"

@implementation AddAlarmViewController

@synthesize timePicker, selectedDays, alarmName, enabled, selectedTime, notificationID, soundAsset;

-(void) viewDidLoad {
    UIBarButtonItem *saveDone = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveToCoreData)];
    self.navigationItem.rightBarButtonItem = saveDone;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:true];
    
}
- (IBAction)pickerTimeChanged:(id)sender forEvent:(UIEvent *)event {
    dispatch_async(dispatch_get_main_queue(), ^ {
        selectedTime = timePicker.date;
        NSLog(@"Date Picker has changed, %@", timePicker.date);
    });
}

-(void)saveToCoreData {
    NSLog(@"message saveToCoreData passed");
    
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

//setting delegates for children
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"repeatSegue"]) {
        DayTableViewController *daysViewController = segue.destinationViewController;
        daysViewController.delegate = self;
    }
}
@end

@interface AddAlarmTableViewController: UITableViewController <MPMediaPickerControllerDelegate>

@property NSString *selectedTitle;

@end

@implementation AddAlarmTableViewController
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell.reuseIdentifier isEqualToString:@"mediaCell"]) {
        UIAlertController *selectTypeAlertController = [UIAlertController alertControllerWithTitle:@"Select Media From" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //Creating actions
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *selectFromMusicAction = [UIAlertAction actionWithTitle:@"Music" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self launchMediaPickerController];
        }];
        UIAlertAction *selectFromToneAction = [UIAlertAction actionWithTitle:@"Tone" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self launchTonePickerController];
        }];
        //adding them to uialertcontroller;
        [selectTypeAlertController addAction:cancelAction];
        [selectTypeAlertController addAction:selectFromMusicAction];
        [selectTypeAlertController addAction:selectFromToneAction];
        [self presentViewController:selectTypeAlertController animated:true completion:nil];
        
    }
}
-(void)launchTonePickerController {
    _selectedTitle = @"alarm";
}
-(void)launchMediaPickerController {
    NSLog(@"Launching MPMediaPickerController");
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    [self presentViewController:mediaPicker animated:true completion:nil];
}

//MPMediaPickerDelegate methods
-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:true completion:^ {
        NSLog(@"MPMediaPickerController dismissed");
    }];
}
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    MPMediaItem *selectedTrack = [[mediaItemCollection items] objectAtIndex:0];
    NSLog(@"%@ selected",selectedTrack.title);
}
@end

