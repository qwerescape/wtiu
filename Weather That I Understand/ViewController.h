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
@interface ViewController : UIViewController<CLLocationManagerDelegate> {
    WeatherService* weatherService;
    CLLocationManager* locationManager;
}
@property (weak, nonatomic) IBOutlet UILabel *technicalWeatherCondition;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

-(void)updateCityName:(NSString*)name;

@end
