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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cityName.alpha = 0;
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
    [self.cityName setText:name];
//    CGRect cityNameFrame = self.cityName.frame;
//    cityNameFrame.origin.y -= 155;
//    CGRect cityNameFrame2 = cityNameFrame;
//    cityNameFrame2.origin.y += 5;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.cityName.alpha = 1.0;
//        self.cityName.frame = cityNameFrame;
    } completion:^(BOOL finished){
//        [UIView animateWithDuration:0.2 animations:^{
//            self.cityName.frame = cityNameFrame2;
//        }];
//        
    }];
}

-(void)updateCurrentWeather:(Weather *)cw yesterday:(Weather *)yw tomorrow:(Weather *)tw{
    current = cw;
    yesterday = yw;
    tomorrow = tw;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isMetric"]){
        [self.todayTemp setText:[NSString stringWithFormat:@"current temperature %.1f°",cw.cfeelLike]];
        [self.todayForecast setText:[NSString stringWithFormat:@"%.0f°/%.0f°", cw.chigh, cw.clow]];
        [self.weatherCondition setText:cw.wc];
        
        //yesterday's weather
        double todayAverage = (cw.chigh + cw.clow)/2;
        double yesterdayAverage = (yw.chigh + yw.clow)/2;
        NSString* yesterdayTempDescription = @"similar to";
        if (todayAverage - yesterdayAverage > 3){
            yesterdayTempDescription = @"hotter than";
        }else if (todayAverage - yesterdayAverage < -3){
            yesterdayTempDescription = @"cooler than";
        }else{
            yesterdayTempDescription = @"similar to";
        }
        
        [self.yesterdayTemp setText:[NSString stringWithFormat:@"%@ yesterday %.0f°/%.0f°", yesterdayTempDescription, yw.chigh, yw.clow]];
        
        NSString* windDescription = @"wind is";
        if (cw.cwind < 5){
            windDescription = @"not much wind";
        }else if (cw.cwind < 20){
            windDescription = @"kinda windy";
        }else {
            windDescription = @"really windy";
        }
        [self.todayWind setText:[NSString stringWithFormat:@"it's %@. %.0f KM", windDescription, cw.cwind]];
    }else{
        [self.todayTemp setText:[NSString stringWithFormat:@"current temperature %.1f°",cw.ffeelslike]];
        [self.todayForecast setText:[NSString stringWithFormat:@"%.0f°/%.0f°", cw.fhigh, cw.flow]];
        [self.weatherCondition setText:cw.wc];
        
        //yesterday's weather
        double todayAverage = (cw.fhigh + cw.flow)/2;
        double yesterdayAverage = (yw.fhigh + yw.flow)/2;
        NSString* yesterdayTempDescription = @"similar to";
        if (todayAverage - yesterdayAverage > 3){
            yesterdayTempDescription = @"hotter than";
        }else if (todayAverage - yesterdayAverage < -3){
            yesterdayTempDescription = @"cooler than";
        }else{
            yesterdayTempDescription = @"similar to";
        }
        
        [self.yesterdayTemp setText:[NSString stringWithFormat:@"%@ yesterday %.0f°/%.0f°", yesterdayTempDescription, yw.fhigh, yw.flow]];
        
        NSString* windDescription = @"wind is";
        if (cw.fwind < 5){
            windDescription = @"not much wind";
        }else if (cw.fwind < 20){
            windDescription = @"kinda windy";
        }else {
            windDescription = @"really windy";
        }
        [self.todayWind setText:[NSString stringWithFormat:@"it's %@. %.0f miles", windDescription, cw.fwind]];
    }
    
    
//    CGRect textFrame = self.technicalWeatherCondition.frame;
//    textFrame.origin.y -= 135;
//    CGRect textFrame2 = textFrame;
//    textFrame2.origin.y += 5;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    } completion:^(BOOL finished){
//        [UIView animateWithDuration:0.2 animations:^{
//            self.technicalWeatherCondition.frame = textFrame2;
//        }];
        
    }];
}

@end
