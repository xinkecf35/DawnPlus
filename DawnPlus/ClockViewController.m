//
//  ViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/23/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "ClockViewController.h"
@implementation ClockViewController

@synthesize clockLabel,latitude,longitude, weatherUpdate, trafficUpdate, weatherTemperature, weatherIcon,trafficInfo;

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
    self.weatherUpdate = [[WeatherFetch alloc] initWithLocation:latitude :longitude];
    self.trafficUpdate = [[TrafficFetch alloc] init];
    self.geocodeService = [[GeocodeFetch alloc]init];
    //Run Geocode Methods
    NSDictionary *workCoordinates = [defaults dictionaryForKey:@"workLocation"];
    if(![workCoordinates isEqual:[NSNull null]]) {
        self.geocodeService.currentLatitude = latitude;
        self.geocodeService.currentLongitude = longitude;
        self.geocodeService.workLatitude = [[workCoordinates valueForKey:@"latitude"] doubleValue];
        self.geocodeService.workLongitude = [[workCoordinates valueForKey:@"longitude"] doubleValue];
    }
    //From Geocode to TrafficFetch coordinates
    self.trafficUpdate.coordinates = [self.geocodeService boundingBoxCalculations];
    
}
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
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
    [[LocationFetch sharedInstance] removeObserver:self forKeyPath:@"currentLocation"];
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
        NSLog(@"%@ observer has received message",self);
        latitude = [LocationFetch sharedInstance].currentLocation.coordinate.latitude;
        longitude = [LocationFetch sharedInstance].currentLocation.coordinate.longitude;
        //Update current lcation for WeatherUpdate and TrafficUpdate
        [self.weatherUpdate setWeatherLocation:latitude :longitude];
        self.geocodeService.workLatitude = latitude;
        self.geocodeService.workLongitude = longitude;
        [self updateServices];
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
    [self.weatherUpdate sendWeatherRequest];
    [self.weatherUpdate setWeatherParameters];
    //Run Geocode Methods
    NSDictionary *workCoordinates = [defaults dictionaryForKey:@"workLocation"];
    if(![workCoordinates isEqual:[NSNull null]]) {
        self.geocodeService.currentLatitude = latitude;
        self.geocodeService.currentLongitude = longitude;
        self.geocodeService.workLatitude = [[workCoordinates valueForKey:@"latitude"] doubleValue];
        self.geocodeService.workLongitude = [[workCoordinates valueForKey:@"longitude"] doubleValue];
    }
    //From Geocode to TrafficFetch coordinates
    self.trafficUpdate.coordinates = [self.geocodeService boundingBoxCalculations];
    [self.trafficUpdate sendTrafficRequest];
    [self.trafficUpdate addTrafficIncidents];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self updateWeatherLabels];
        [self updateTrafficLabels];
    });
    
}
-(void) updateWeatherLabels
{
    NSString *temp = [NSString stringWithFormat:@"%@%@F",self.weatherUpdate.currentTemperature, @"\u00B0"];
    if([self.weatherUpdate.isFarenheit boolValue] == false)
    {
        temp = [NSString stringWithFormat:@"%@%@C",self.weatherUpdate.currentTemperature, @"\u00B0"];
    }
    
    self.weatherTemperature.text = temp;
    
    UIImage *currentIcon = [UIImage imageNamed:self.weatherUpdate.currentCondition];
    weatherIcon.image = currentIcon;
    //Logging displays of weather UILabels
    NSLog(@"%@ method updateWeatherLabels displaying temperature of %@ and icon %@",self, temp,self.weatherUpdate.currentCondition);
}
-(void)updateTrafficLabels
{
    NSLog(@"Nothing Yet");
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
    }
}

@end
