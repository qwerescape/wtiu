//
//  ViewController.h
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-04-19.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class WeatherService;
@class Weather;
@interface ViewController : UIViewController<CLLocationManagerDelegate> {
    WeatherService* weatherService;
    CLLocationManager* locationManager;
    Weather* current;
    Weather* yesterday;
    Weather* tomorrow;
}
@property (weak, nonatomic) IBOutlet UILabel *todayTemp;
@property (weak, nonatomic) IBOutlet UILabel *weatherCondition;
@property (weak, nonatomic) IBOutlet UILabel *todayForecast;
@property (weak, nonatomic) IBOutlet UILabel *todayWind;

@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayTemp;
@property (weak, nonatomic) IBOutlet UILabel *tomorrowTemp;
- (IBAction)cfValueSwitched:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *cfSwitch;

@property (weak, nonatomic) IBOutlet UIProgressView *loader;
-(void)updateCityName:(NSString*)name;
-(void)updateCurrentWeather:(Weather*)cw yesterday:(Weather*)yw tomorrow:(Weather*)tw;
@end
