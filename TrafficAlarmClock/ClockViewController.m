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
    //Fetch Weather Updates
    [self.weatherUpdate sendWeatherRequest];
    [self.weatherUpdate setWeatherParameters];
    //Geocoding workLocation
    [self.geocodeService setWorkAddress:@"600 N Ithan Ave, Bryn Mawr, PA 19010"];
    [self.geocodeService geocodeWorkLocation];
    //From Geocode to TrafficFetch coordinates
    self.trafficUpdate.coordinates = [self.geocodeService boundingBoxCalculations];
    [self.trafficUpdate sendTrafficRequest];
    [self.trafficUpdate addTrafficIncidents];
    [self updateWeatherLabels];
    [self updateTrafficLabels];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(didDefaultsChange:)
            name:NSUserDefaultsDidChangeNotification
            object:nil];
    
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
        
        //GeocodeService Update;
        self.geocodeService.currentLatitude = latitude;
        self.geocodeService.currentLongitude = longitude;
        
        [self.weatherUpdate sendWeatherRequest];
        [self.weatherUpdate setWeatherParameters];
        
        [self.geocodeService setWorkAddress:@"600 N Ithan Ave, Bryn Mawr, PA 19010"];
        [self.geocodeService geocodeWorkLocation];
        //From Geocode to TrafficFetch coordinates
        self.trafficUpdate.coordinates = [self.geocodeService boundingBoxCalculations];
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
    if([self.weatherUpdate.isFarenheit boolValue] == false)
    {
        temp = [NSString stringWithFormat:@"%@%@C",self.weatherUpdate.currentTemperature, @"\u00B0"];
    }
    
    self.weatherTemperature.text = temp;
    
    UIImage *currentIcon = [UIImage imageNamed:self.weatherUpdate.currentCondition];
    [weatherIcon setImage:currentIcon];
    //Logging displays of weather UILabels
    NSLog(@"%@ method updateWeatherLabels displaying temperature of %@ and icon %@",self, temp,self.weatherUpdate.currentCondition);
}
-(void)updateTrafficLabels
{
    int lowSeverity = 0;
    int highSeverity = 0;
    //Determining overall status of traffic
    if(self.trafficUpdate.status != 0)
    {
        UIImage *errorImage = [UIImage imageNamed:@"error"];
        [trafficInfo setImage:errorImage forState:UIControlStateNormal];
        NSLog(@"No traffic data is available");
        
    }
    else
    {
        NSArray *incidents = self.trafficUpdate.trafficIncidents;
        //Handling no incidents to be reported
        if([incidents[0] isEqual:[NSNull null]])
        {
            UIImage *checkMark = [UIImage imageNamed:@"check-mark"];
            [trafficInfo setImage:checkMark forState:UIControlStateNormal];
            NSLog(@"%@ no incidents available",self);
            return;
        }
        //Totaling severity events, divided into split into 0-2 and 3-4, inclusive
        for(id incident in incidents)
        {
            switch ([[incident valueForKey:@"severity"] intValue]) {
                case -1:
                    lowSeverity = 0;
                    highSeverity = 0;
                    break;
                case 0:
                    lowSeverity++;
                    break;
                case 1:
                    lowSeverity++;
                    break;
                case 2:
                    lowSeverity++;
                    break;
                case 3:
                    highSeverity++;
                    break;
                case 4:
                    highSeverity++;
                    break;
                default:
                    break;
            }
        }
        NSLog(@"Number of low severity events: %d; Number of high severity events: %d",lowSeverity,highSeverity);
        //Determining overall severity
        if(lowSeverity == 0 && highSeverity == 0)
        {
            UIImage *checkMark = [UIImage imageNamed:@"check-mark"];
            [trafficInfo setImage:checkMark forState:UIControlStateNormal];
            NSLog(@"%@ no incidents available",self);
        }
        else if(lowSeverity >= highSeverity*2)
        {
            UIImage *caution = [UIImage imageNamed:@"caution"];
            [trafficInfo setImage:caution forState:UIControlStateNormal];
            NSLog(@"%@ is displaying icon caution for trafficInfo",self);
        }
        else if(lowSeverity < highSeverity*2)
        {
            UIImage *cautionRed = [UIImage imageNamed:@"caution-red"];
            [trafficInfo setImage:cautionRed forState:UIControlStateNormal];
            NSLog(@"%@ is displaying icon caution-red for trafficInfo",self);
        }
        else
        {
            UIImage *errorImage = [UIImage imageNamed:@"error"];
            [trafficInfo setImage:errorImage forState:UIControlStateNormal];
            NSLog(@"Dear God, this should not even be possible, something has gone seriously wrong");
        }
        
        //Logging displays of traffic UILabel
        NSLog(@"%@ method updateTrafficLabels displays %lu traffic incidents",self,[self.trafficUpdate.trafficIncidents count]);
    }
}
//NSUserDefaults NSNotificationCenter Observer

//Update various labels for changes in NSUserDefaults
-(void)didDefaultsChange:(NSNotification *)notifictation
{
    //WeatherUpdate updates for change in NSUserDefaults
    [self.weatherUpdate sendWeatherRequest];
    [self.weatherUpdate setWeatherParameters];
    [self updateWeatherLabels];
    [self.trafficUpdate sendTrafficRequest];
    [self.trafficUpdate addTrafficIncidents];
    [self updateTrafficLabels];
    NSLog(@"%@ has been received and responded to",notifictation);
    
}

-(IBAction)unwindToClockView:(UIStoryboardSegue*)sender;
{
    NSLog(@"Back to Clock View");
}

@end
