//
//  ViewController.m
//  TrafficAlarmClock
//
//  Created by Xinke Chen on 5/23/16.
//  Copyright © 2016 Xinke Chen. All rights reserved.
//

#import "ViewController.h"
@implementation ViewController

@synthesize clockLabel, latitude,longitude, weatherUpdate, trafficUpdate, weatherTemperature, weatherIcon;

-(void)viewDidLoad {
    [super viewDidLoad];
    [self updateClockLabel];
    
    [[LocationFetch sharedInstance] startingUpdatingLocation];
    latitude = [LocationFetch sharedInstance].currentLocation.coordinate.latitude;
    longitude = [LocationFetch sharedInstance].currentLocation.coordinate.longitude;
    
    [[LocationFetch sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    
    self.weatherUpdate = [[WeatherFetch alloc] initWithLocation:latitude :longitude];
    self.trafficUpdate = [[TrafficFetch alloc] initWithLocation:latitude :longitude];
    
    [self.weatherUpdate sendWeatherRequest];
    [self.weatherUpdate setWeatherParameters];
    [self.trafficUpdate setWorkLocation:@"600 N Ithan Ave, Bryn Mawr, PA 19010"];
    [self.trafficUpdate geocodeWorkLocation];
    [self.trafficUpdate sendTrafficRequest];
    [self.trafficUpdate addTrafficIncidents];
    [self updateWeatherLabels];
    [self updateTrafficLabels];
    
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
        NSLog(@"Observer has received message");
        latitude = [LocationFetch sharedInstance].currentLocation.coordinate.latitude;
        longitude = [LocationFetch sharedInstance].currentLocation.coordinate.longitude;
        [self.weatherUpdate setWeatherLocation:latitude :longitude];
        [self.trafficUpdate setCurrentCoordinates:latitude :longitude];
        [self.weatherUpdate sendWeatherRequest];
        [self.weatherUpdate setWeatherParameters];
        [self.trafficUpdate geocodeWorkLocation];
        [self.trafficUpdate sendTrafficRequest];
        [self.trafficUpdate addTrafficIncidents];
        [self updateWeatherLabels];
        [self updateTrafficLabels];
        
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
-(void) updateWeatherLabels
{
    NSString *temp = [NSString stringWithFormat:@"%@%@F",self.weatherUpdate.currentTemperature, @"\u00B0"];
    self.weatherTemperature.text = temp;
    UIImage *currentIcon = [UIImage imageNamed:self.weatherUpdate.currentCondition];
    [weatherIcon setImage:currentIcon];
    //Logging displays of weather UILabels
    NSLog(@"%@ method updateWeatherLabels displaying temperature of %@ and icon %@",self, temp,self.weatherUpdate.currentCondition);
}
-(void)updateTrafficLabels
{
    self.numberOfTrafficIncidents.text = [NSString stringWithFormat:@"%lu",[self.trafficUpdate.trafficIncidents count]];
    //Logging displays of traffic UILabels
    NSLog(@"%@ method updateTrafficLabels displays %lu traffic incidents",self,[self.trafficUpdate.trafficIncidents count]);
}
-(IBAction)toggleSettings:(id)sender
{
    
}
@end
