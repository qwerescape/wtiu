//
//  ViewController.m
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-04-19.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import "ViewController.h"
#import "WeatherService.h"
#import "Weather.h"
@interface ViewController ()
-(void)loading;
-(void)loaded;
@end

@implementation ViewController

-(void)loading{
    self.todayTemp.alpha = 0;
    self.weatherCondition.alpha = 0;
    self.todayForecast.alpha = 0;
    self.todayWind.alpha = 0;
    self.cityName.alpha = 0;
    self.yesterdayTemp.alpha = 0;
    self.tomorrowTemp.alpha = 0;
    self.cfSwitch.alpha = 0;
}

-(void)loaded{
    self.todayTemp.alpha = 1;
    self.weatherCondition.alpha = 1;
    self.todayForecast.alpha = 1;
    self.todayWind.alpha = 1;
    self.cityName.alpha = 1;
    self.yesterdayTemp.alpha = 1;
    self.tomorrowTemp.alpha = 1;
    self.cfSwitch.alpha = 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loading];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 20000;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    //set default celcius ferenheight switch
    [self.cfSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"isMetric"]];

	weatherService = [[WeatherService alloc]initWithViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [locationManager stopUpdatingLocation];
    CLLocation* firstLocation = [locations objectAtIndex:0];
    double lat = [firstLocation coordinate].latitude;
    double lng = [firstLocation coordinate].longitude;
    [weatherService getCurrentWeatherForLatitude:lat longitude:lng];
}

- (IBAction)cfValueSwitched:(id)sender {
    UISwitch* s = (UISwitch*)sender;
    [[NSUserDefaults standardUserDefaults]setBool:s.isOn forKey:@"isMetric"];
    [self updateCurrentWeather:current yesterday:yesterday tomorrow:tomorrow];

}

-(void)updateCityName:(NSString *)name{
    [self.cityName setText:[NSString stringWithFormat:@"%@ now:", name]];
}

-(void)updateCurrentWeather:(Weather *)cw yesterday:(Weather *)yw tomorrow:(Weather *)tw{
    current = cw;
    yesterday = yw;
    tomorrow = tw;
    
    double currentFeelsLike = cw.cfeelLike;
    double currentHigh = cw.chigh;
    double currentLow = cw.clow;
    double currentWind = cw.cwind;
    
    double yesterdayHigh = yw.chigh;
    double yesterdayLow = yw.clow;
    
    double tomorrowHigh = tw.chigh;
    double tomorrowLow = tw.clow;
    
    NSString* windUnit = @"km";
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isMetric"]){
        currentFeelsLike = cw.ffeelslike;
        currentHigh = cw.fhigh;
        currentLow = cw.flow;
        currentWind = cw.fwind;

        yesterdayHigh = yw.fhigh;
        yesterdayLow = yw.flow;

        tomorrowHigh = tw.fhigh;
        tomorrowLow = tw.flow;
        windUnit = @"miles";
        
    }
    [self.todayTemp setText:[NSString stringWithFormat:@"NOW feels like %.1f°",currentFeelsLike]];
    [self.todayForecast setText:[NSString stringWithFormat:@"%.0f°/%.0f°", currentHigh, currentLow]];
    [self.weatherCondition setText:cw.wc];
    
    //yesterday's weather
    double todayAverage = (currentHigh + currentLow)/2;
    double yesterdayAverage = (yesterdayHigh + yesterdayLow)/2;
    NSString* yesterdayTempDescription = @"Similar to";
    if (todayAverage - yesterdayAverage > 3){
        yesterdayTempDescription = @"Hotter than";
    }else if (todayAverage - yesterdayAverage < -3){
        yesterdayTempDescription = @"Cooler than";
    }else{
        yesterdayTempDescription = @"Similar to";
    }
    
    [self.yesterdayTemp setText:[NSString stringWithFormat:@"%@ YESTERDAY %.0f°/%.0f°", yesterdayTempDescription, yesterdayHigh, yesterdayLow]];
    
    
    //tomorrow weather
    double tomorrowAverage = (tomorrowHigh + tomorrowLow)/2;
    NSString* tomorrowTempDescription = @"similar to";
    if (todayAverage - tomorrowAverage > 3){
        tomorrowTempDescription = @"Hotter than";
    }else if (todayAverage - tomorrowAverage < -3){
        tomorrowTempDescription = @"Cooler than";
    }else{
        tomorrowTempDescription = @"Similar to";
    }
    
    [self.tomorrowTemp setText:[NSString stringWithFormat:@"%@ TOMORROW %.0f°/%.0f°", tomorrowTempDescription, tomorrowHigh, tomorrowLow]];
    
    NSString* windDescription = @"wind is";
    if (currentWind < 5){
        windDescription = @"not much wind";
    }else if (currentWind < 20){
        windDescription = @"kinda windy";
    }else {
        windDescription = @"really windy";
    }
    [self.todayWind setText:[NSString stringWithFormat:@"%@. %.0f %@", windDescription, currentWind, windUnit]];
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.loader.alpha = 0;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.6 animations:^{
            [self loaded];
        }];        
    }];
    
}

@end
