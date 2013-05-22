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
-(void)setInfoWithCity:(NSString*)city
         todayForecast:(NSString*)todayForecast
            relativeTo:(NSString*)relativeTo
   relativePreposition:(NSString*)relativePreposition
             yesterday:(NSString*)yesterdayWeather
               current:(NSString*)currentFeel
           weatherCond:(NSString*)weatherCond
              windDesc:(NSString*)windDesc
             windSpeed:(NSString*)windSpeed;
@end

@implementation ViewController

-(void)loading{
    self.cfSwitch.alpha = 0;
}

-(void)loaded{
    self.cfSwitch.alpha = 1;
}

-(void)setInfoWithCity:(NSString*)city
         todayForecast:(NSString*)todayForecast
            relativeTo:(NSString*)relativeTo
   relativePreposition:(NSString*)relativePreposition
             yesterday:(NSString*)yesterdayWeather
               current:(NSString*)currentFeel
           weatherCond:(NSString*)weatherCond
              windDesc:(NSString*)windDesc
             windSpeed:(NSString*)windSpeed{

    UIFont *specialFont=[UIFont fontWithName:@"Helvetica" size:20.0f];
    UIColor *specialFontColor=[UIColor colorWithRed:0.87 green:0.352 blue:0.371 alpha:1];
    UIColor *normalFontColor=[UIColor colorWithRed:0.306 green:0.306 blue:0.306 alpha:1];
    UIFont *normalFont=[UIFont fontWithName:@"Helvetica" size:18.0f];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy.gif"]]];
    
    
    NSString* fillerText = [NSString stringWithFormat:
                            @"You are in {1}, beautiful. "
                            "My sources say today is {2}, "
                            "which is {3} %@ yesterday's %@. "
                            "Currently it feels like {4}. "
                            "Overall today it'll be {5}, "
                            "and it is {6}, %@.", relativePreposition, yesterdayWeather, windSpeed];
    NSMutableAttributedString* attrFillerText = [[NSMutableAttributedString alloc] initWithString:fillerText];
    
    [attrFillerText addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, attrFillerText.length)];
    [attrFillerText addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, attrFillerText.length)];
    
    NSMutableAttributedString* cityName = [[NSMutableAttributedString alloc] initWithString:city];
    
    [cityName addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, cityName.length)];
    [cityName addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, cityName.length)];
    
    [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{1}"] withAttributedString:cityName];
    
    NSMutableAttributedString* todayForecastTemp = [[NSMutableAttributedString alloc] initWithString:todayForecast];
    [todayForecastTemp addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, todayForecastTemp.length)];
    [todayForecastTemp addAttribute:NSForegroundColorAttributeName value:specialFontColor range:NSMakeRange(0, todayForecastTemp.length)];
    [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{2}"] withAttributedString:todayForecastTemp];
    
    NSMutableAttributedString* yesterdayCompare = [[NSMutableAttributedString alloc] initWithString:relativeTo];
    [yesterdayCompare addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, yesterdayCompare.length)];
    [yesterdayCompare addAttribute:NSForegroundColorAttributeName value:specialFontColor range:NSMakeRange(0, yesterdayCompare.length)];
    [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{3}"] withAttributedString:yesterdayCompare];
    
    
    NSMutableAttributedString* currentTemp = [[NSMutableAttributedString alloc] initWithString:currentFeel];
    [currentTemp addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, currentTemp.length)];
    [currentTemp addAttribute:NSForegroundColorAttributeName value:specialFontColor range:NSMakeRange(0, currentTemp.length)];
    [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{4}"] withAttributedString:currentTemp];
    
    NSMutableAttributedString* currentWeather = [[NSMutableAttributedString alloc] initWithString:weatherCond];
    [currentWeather addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, currentWeather.length)];
    [currentWeather addAttribute:NSForegroundColorAttributeName value:specialFontColor range:NSMakeRange(0, currentWeather.length)];
    [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{5}"] withAttributedString:currentWeather];
    
    NSMutableAttributedString* currentWind = [[NSMutableAttributedString alloc] initWithString:windDesc];
    [currentWind addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, currentWind.length)];
    [currentWind addAttribute:NSForegroundColorAttributeName value:specialFontColor range:NSMakeRange(0, currentWind.length)];
    [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{6}"] withAttributedString:currentWind];
    
    NSInteger strLength = [attrFillerText length];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:15];
    [attrFillerText addAttribute:NSParagraphStyleAttributeName
                      value:style
                      range:NSMakeRange(0, strLength)];
    
    self.weatherText.attributedText = attrFillerText;
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

-(void)setProgress:(float)progress{
    
}

-(void)updateCityName:(NSString *)name{
    currentCity = name;
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
    
    NSString* windUnit = @"km/h";
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isMetric"]){
        currentFeelsLike = cw.ffeelslike;
        currentHigh = cw.fhigh;
        currentLow = cw.flow;
        currentWind = cw.fwind;

        yesterdayHigh = yw.fhigh;
        yesterdayLow = yw.flow;

        tomorrowHigh = tw.fhigh;
        tomorrowLow = tw.flow;
        windUnit = @"miles/h";
        
    }
    
    //yesterday's weather
    double todayAverage = (currentHigh + currentLow)/2;
    double yesterdayAverage = (yesterdayHigh + yesterdayLow)/2;
    NSString* yesterdayTempDescription = @"similar";
    NSString* yesterdayTempPreposition = @"to";
    if (todayAverage - yesterdayAverage > 3){
        yesterdayTempDescription = @"hotter";
        yesterdayTempPreposition = @"than";
    }else if (todayAverage - yesterdayAverage < -3){
        yesterdayTempDescription = @"cooler";
        yesterdayTempPreposition = @"than";
    }
    
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
    
    NSString* windDescription = @"wind is";
    if (currentWind < 5){
        windDescription = @"not much wind";
    }else if (currentWind < 20){
        windDescription = @"kinda windy";
    }else {
        windDescription = @"really windy";
    }
    
    [self setInfoWithCity:currentCity
            todayForecast:[NSString stringWithFormat:@"%.0f/%.0f", currentHigh, currentLow]
               relativeTo:yesterdayTempDescription
      relativePreposition:yesterdayTempPreposition
                yesterday:[NSString stringWithFormat:@"%.0f/%.0f", yesterdayHigh, yesterdayLow]
                  current:[NSString stringWithFormat:@"%.0f",currentFeelsLike]
              weatherCond:[cw.wc lowercaseString]
                 windDesc:windDescription
                windSpeed:[NSString stringWithFormat:@"%.0f %@", currentWind, windUnit]];
    
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self loaded];
    } completion:^(BOOL finished){
    }];
    
}

@end
