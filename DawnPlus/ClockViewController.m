//
//  ViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/23/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "ClockViewController.h"
@implementation ClockViewController

@synthesize clockLabel,latitude,longitude, weatherUpdate, trafficUpdate, weatherTemperature, weatherIcon,trafficInfo,geocodeService;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(didDefaultsChange:)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
    defaults = NSUserDefaults.standardUserDefaults;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self updateClockLabel];
    //Starting Location Updates
    [[LocationFetch sharedInstance] startingUpdatingLocation];
    latitude = [LocationFetch sharedInstance].currentLocation.coordinate.latitude;
    longitude = [LocationFetch sharedInstance].currentLocation.coordinate.longitude;
    [[LocationFetch sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    //Instantiating  weatherUpdate, trafficUpdate, and geocodeService
    weatherUpdate = [[WeatherFetch alloc] initWithLocation:latitude :longitude];
    trafficUpdate = [[TrafficFetch alloc] init];
    weatherUpdate.defaults= [NSUserDefaults standardUserDefaults];
    trafficUpdate.userDefaults = [NSUserDefaults standardUserDefaults];
    //adding KVO observers
    [trafficUpdate addObserver:self forKeyPath:@"trafficData" options:NSKeyValueObservingOptionNew context:nil];
    [weatherUpdate addObserver:self forKeyPath:@"weatherData" options:NSKeyValueObservingOptionNew context:nil];
    geocodeService = [[GeocodeFetch alloc]init];
    //Run Geocode Methods
    NSDictionary *workCoordinates = [defaults dictionaryForKey:@"workLocation"];
    if(![workCoordinates isEqual:[NSNull null]]) {
        geocodeService.currentLatitude = latitude;
        geocodeService.currentLongitude = longitude;
        geocodeService.workLatitude = [[workCoordinates valueForKey:@"latitude"] doubleValue];
        geocodeService.workLongitude = [[workCoordinates valueForKey:@"longitude"] doubleValue];
    }
    //From Geocode to TrafficFetch coordinates
    trafficUpdate.coordinates = [geocodeService boundingBoxCalculations];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
    [[LocationFetch sharedInstance] removeObserver:self forKeyPath:@"currentLocation"];
    [trafficUpdate removeObserver:self forKeyPath:@"trafficData"];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//KVO for ViewController
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentLocation"])
    {
        NSLog(@"%@ observer has received message for currentLocation",self);
        latitude = [LocationFetch sharedInstance].currentLocation.coordinate.latitude;
        longitude = [LocationFetch sharedInstance].currentLocation.coordinate.longitude;
        //Update current location for WeatherUpdate and TrafficUpdate
        [weatherUpdate setWeatherLocation:latitude :longitude];
        geocodeService.currentLatitude = latitude;
        geocodeService.currentLongitude = longitude;
        trafficUpdate.coordinates = [geocodeService boundingBoxCalculations];
        [self updateServices];
    } else if([keyPath isEqualToString:@"trafficData"]) {
        NSLog(@"%@ observer has received message for trafficData",self);
        [trafficUpdate addTrafficIncidents];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateTrafficLabels];
        });
    } else if([keyPath isEqualToString:@"weatherData"]) {
        NSLog(@"%@ observer has received message for weatherData",self);
        [weatherUpdate setWeatherParameters];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateWeatherLabels];
        });
    }
}
//Interface methods
-(void)updateClockLabel
{
    NSDateFormatter *clockFormat= [[NSDateFormatter alloc] init];
    [clockFormat setDateFormat:@"h:mm a"];
    self.clockLabel.text = [clockFormat stringFromDate:[NSDate date]];
    [self performSelector:@selector(updateClockLabel) withObject:self afterDelay:1.0];
}
-(void) updateServices {
    [weatherUpdate sendWeatherRequest];
    //Run Geocode Methods
    NSDictionary *workCoordinates = [defaults dictionaryForKey:@"workLocation"];
    if(![workCoordinates isEqual:[NSNull null]]) {
        geocodeService.currentLatitude = latitude;
        geocodeService.currentLongitude = longitude;
        geocodeService.workLatitude = [[workCoordinates valueForKey:@"latitude"] doubleValue];
        geocodeService.workLongitude = [[workCoordinates valueForKey:@"longitude"] doubleValue];
    }
    //From Geocode to TrafficFetch coordinates
    trafficUpdate.coordinates = [geocodeService boundingBoxCalculations];
    [trafficUpdate sendTrafficRequest];
}
-(void) updateWeatherLabels
{
    NSString *temp = [NSString stringWithFormat:@"%@%@F",weatherUpdate.currentTemperature, @"\u00B0"];
    if([weatherUpdate.isFarenheit boolValue] == false)
    {
        temp = [NSString stringWithFormat:@"%@%@C",weatherUpdate.currentTemperature, @"\u00B0"];
    }
    
    self.weatherTemperature.text = temp;
    
    UIImage *currentIcon = [UIImage imageNamed:weatherUpdate.currentCondition];
    [weatherIcon setImage:currentIcon forState:UIControlStateNormal];
    //Logging displays of weather UILabels
    NSLog(@"%@ method updateWeatherLabels displaying temperature of %@ and icon %@",self, temp,weatherUpdate.currentCondition);
}
-(void)updateTrafficLabels
{
    switch ([trafficUpdate rankOverallSeverity]) {
        case -1:
            if(trafficUpdate.status == 200) {
                [trafficInfo setImage:[UIImage imageNamed:@"check-mark"] forState:UIControlStateNormal];
                NSLog(@"For no incidents setting checkmark");
            } else {
                [trafficInfo setImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
                NSLog(@"Error on GET request, status: %ld",(long)trafficUpdate.status);
            }
            break;
        case 0:
            [trafficInfo setImage:[UIImage imageNamed:@"caution-red"] forState:UIControlStateNormal];
            NSLog(@"For critical ranking setting caution-red");
            break;
        case 3:
            [trafficInfo setImage:[UIImage imageNamed:@"caution-red"] forState:UIControlStateNormal];
            NSLog(@"For critical ranking setting caution-red");
            break;
        case 2:
            [trafficInfo setImage:[UIImage imageNamed:@"caution"] forState:UIControlStateNormal];
            NSLog(@"For minor ranking setting caution");
            break;
        case 1:
            [trafficInfo setImage:[UIImage imageNamed:@"check-mark"] forState:UIControlStateNormal];
            NSLog(@"For lowImpact ranking setting checkmark");
            break;
        default:
            [trafficInfo setImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
            NSLog(@"Oh dear, something has gone seriously wrong has gone wrong with trafficUpdate");
            break;
    }
}
//NSUserDefaults NSNotificationCenter Observer

//Update various labels for changes in NSUserDefaults
-(void)didDefaultsChange:(NSNotification *)notifictation
{
    //WeatherUpdate updates for change in NSUserDefaults
    [self updateServices];
    NSLog(@"%@ has been received and responded to",notifictation);
    
}
//Segues
-(IBAction)unwindToClockView:(UIStoryboardSegue*)sender;
{
    NSLog(@"Back to Clock View");
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"AlarmViewSegue"]) {
        AlarmTableViewController *alarmVC = [[[segue destinationViewController] childViewControllers] objectAtIndex:0];
        alarmVC.coreDataManager = self.coreDataManager;
        alarmVC.notificationManager = self.notificationManager;
    }
}

@end
