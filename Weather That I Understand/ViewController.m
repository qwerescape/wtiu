//
//  ViewController.m
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-04-19.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import "ViewController.h"
#import "WeatherService.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.technicalWeatherCondition.hidden = YES;
    self.cityName.alpha = 0;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 20000;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];

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

-(void)updateCityName:(NSString *)name{
    [self.cityName setText:name];
    CGRect cityNameFrame = self.cityName.frame;
    cityNameFrame.origin.y -= 155;
    CGRect cityNameFrame2 = cityNameFrame;
    cityNameFrame2.origin.y += 5;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.cityName.alpha = 1.0;
        self.cityName.frame = cityNameFrame;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^{
            self.cityName.frame = cityNameFrame2;
        }];
        
    }];
}

@end
