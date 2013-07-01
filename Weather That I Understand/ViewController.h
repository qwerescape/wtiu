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
    NSDate* lastLoadedDate;
    NSString* currentCity;
}
@property (weak, nonatomic) IBOutlet UILabel *weatherText;
-(void)updateCityName:(NSString*)name;
-(void)updateCurrentWeather:(Weather*)cw yesterday:(Weather*)yw tomorrow:(Weather*)tw;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
-(void)setProgress:(float)progress;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@end
