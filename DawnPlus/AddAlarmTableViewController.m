//
//  AddAlarmTableViewController.m
//  DawnPlus
//
//  Created by Xinke Chen on 2017-07-30.
//  Copyright © 2017 Xinke Chen. All rights reserved.
//

#import "AddAlarmTableViewController.h"
#import "ToneTableViewController.h"

@interface AddAlarmTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mediaCellLabel;

@end

@implementation AddAlarmTableViewController


@synthesize previousLabel, previousSoundAsset, previousRepeatArray,alarmDelegate,mediaCellLabel;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    dispatch_async(dispatch_get_main_queue(), ^ {
        if(previousSoundAsset != nil) {
            mediaCellLabel.text = previousSoundAsset;
        } else {
            mediaCellLabel.text = @" ";
        }
    });
}

- (void)viewDidLoad {
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)launchTonePickerController {
    ToneTableViewController *toneVC = [[ToneTableViewController alloc] init];
    toneVC.alarmDelegate = alarmDelegate;
    [self.navigationController pushViewController:toneVC animated:true];
    
}

- (void)launchMediaPickerController {
    NSLog(@"Launching MPMediaPickerController");
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO;
    
    [self presentViewController:mediaPicker animated:true completion:nil];
}

//MPMediaPickerDelegate methods
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissViewControllerAnimated:true completion:^ {
        NSLog(@"MPMediaPickerController dismissed");
    }];
}
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    MPMediaItem *selectedTrack = [[mediaItemCollection items] objectAtIndex:0];
    alarmDelegate.soundAsset = selectedTrack.title;
    alarmDelegate.appTones = [[NSNumber alloc] initWithBool:NO];
    [self dismissViewControllerAnimated:true completion:^ {
        dispatch_async(dispatch_get_main_queue(), ^ {
            mediaCellLabel.text = alarmDelegate.soundAsset;
            NSLog(@"MPMediaPickerController dismissed with %@", alarmDelegate.soundAsset);
        });
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"repeatSegue"]) {
        DayTableViewController *daysViewController = segue.destinationViewController;
        daysViewController.alarmDelegate = alarmDelegate;
        if(previousRepeatArray != nil) {
            daysViewController.previousSelection = previousRepeatArray;
        }
    }
    else if([segue.identifier isEqualToString:@"labelSegue"]) {
        LabelViewController *labelViewController = segue.destinationViewController;
        labelViewController.alarmDelegate = alarmDelegate;
        if(previousLabel != nil) {
            labelViewController.previousLabel = previousLabel;
        }
    }
}
@end
