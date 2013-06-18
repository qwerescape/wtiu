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

-(void)setInfoWithCity:(NSString*)city
         todayForecast:(NSString*)todayForecast
            relativeTo:(NSString*)relativeTo
   relativePreposition:(NSString*)relativePreposition
             yesterday:(NSString*)yesterdayWeather
               current:(NSString*)currentFeel
           weatherCond:(NSString*)weatherCond
              windDesc:(NSString*)windDesc
             windSpeed:(NSString*)windSpeed{

    UIFont *specialFont=[UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f];
    UIColor *specialFontColor=[UIColor colorWithRed:0.87 green:0.352 blue:0.371 alpha:1];
//    UIColor *normalFontColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    UIColor *normalFontColor=[UIColor colorWithRed:0.306 green:0.306 blue:0.306 alpha:1];
    UIFont *normalFont=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    
    //get user string, if not, use default
    NSString* displayString = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_message"];
    if (displayString == nil){
        displayString = [Weather getDefaultMessageString];
    }
    
    NSString* fillerText = displayString;
    NSMutableAttributedString* attrFillerText = [[NSMutableAttributedString alloc] initWithString:fillerText];
    
    [attrFillerText addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, attrFillerText.length)];
    [attrFillerText addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, attrFillerText.length)];

    if ([attrFillerText.string rangeOfString:@"{city}"].location != NSNotFound){
        NSMutableAttributedString* cityName = [[NSMutableAttributedString alloc] initWithString:city];
        
        [cityName addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, cityName.length)];
        [cityName addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, cityName.length)];
        
        [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{city}"] withAttributedString:cityName];
    }
    
    if ([attrFillerText.string rangeOfString:@"{today_forecast}"].location != NSNotFound){
        NSMutableAttributedString* todayForecastTemp = [[NSMutableAttributedString alloc] initWithString:todayForecast];
        [todayForecastTemp addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, todayForecastTemp.length)];
        [todayForecastTemp addAttribute:NSForegroundColorAttributeName value:specialFontColor range:NSMakeRange(0, todayForecastTemp.length)];
        [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{today_forecast}"] withAttributedString:todayForecastTemp];
    }
    
    if ([attrFillerText.string rangeOfString:@"{yesterday_forecast}"].location != NSNotFound){
        NSMutableAttributedString* yesterdayForecastTemp = [[NSMutableAttributedString alloc] initWithString:yesterdayWeather];
        [yesterdayForecastTemp addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, yesterdayForecastTemp.length)];
        [yesterdayForecastTemp addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, yesterdayForecastTemp.length)];
        [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{yesterday_forecast}"] withAttributedString:yesterdayForecastTemp];
    }
    
    if ([attrFillerText.string rangeOfString:@"{hotter_colder}"].location != NSNotFound){
        NSMutableAttributedString* yesterdayCompare = [[NSMutableAttributedString alloc] initWithString:relativeTo];
        [yesterdayCompare addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, yesterdayCompare.length)];
        [yesterdayCompare addAttribute:NSForegroundColorAttributeName value:specialFontColor range:NSMakeRange(0, yesterdayCompare.length)];
   
        NSMutableAttributedString* preposition = [[NSMutableAttributedString alloc] initWithString:relativePreposition];
        [preposition addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, preposition.length)];
        [preposition addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, preposition.length)];
        
        [yesterdayCompare appendAttributedString:preposition];
        
        [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{hotter_colder}"] withAttributedString:yesterdayCompare];
    }
    
    if ([attrFillerText.string rangeOfString:@"{current_temp}"].location != NSNotFound){
        NSMutableAttributedString* currentTemp = [[NSMutableAttributedString alloc] initWithString:currentFeel];
        [currentTemp addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, currentTemp.length)];
        [currentTemp addAttribute:NSForegroundColorAttributeName value:specialFontColor range:NSMakeRange(0, currentTemp.length)];
        [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{current_temp}"] withAttributedString:currentTemp];
    }
    
    if ([attrFillerText.string rangeOfString:@"{weather_cond}"].location != NSNotFound){
        NSMutableAttributedString* currentWeather = [[NSMutableAttributedString alloc] initWithString:weatherCond];
        [currentWeather addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, currentWeather.length)];
        [currentWeather addAttribute:NSForegroundColorAttributeName value:specialFontColor range:NSMakeRange(0, currentWeather.length)];
        [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{weather_cond}"] withAttributedString:currentWeather];
    }
    
    if ([attrFillerText.string rangeOfString:@"{wind_cond}"].location != NSNotFound){
        NSMutableAttributedString* currentWind = [[NSMutableAttributedString alloc] initWithString:windDesc];
        [currentWind addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, currentWind.length)];
        [currentWind addAttribute:NSForegroundColorAttributeName value:specialFontColor range:NSMakeRange(0, currentWind.length)];
        [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{wind_cond}"] withAttributedString:currentWind];
    }
    
    if ([attrFillerText.string rangeOfString:@"{wind_speed}"].location != NSNotFound){        
        NSMutableAttributedString* currentWindSpeed = [[NSMutableAttributedString alloc] initWithString:windSpeed];
        [currentWindSpeed addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, currentWindSpeed.length)];
        [currentWindSpeed addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, currentWindSpeed.length)];
        [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{wind_speed}"] withAttributedString:currentWindSpeed];
    }
    
    
    NSInteger strLength = [attrFillerText length];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:13];
    [attrFillerText addAttribute:NSParagraphStyleAttributeName
                      value:style
                      range:NSMakeRange(0, strLength)];
    
    self.weatherText.attributedText = attrFillerText;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy.gif"]]];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 20000;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    self.weatherText.alpha = 0;
    self.buttonView.alpha = 0;
	weatherService = [[WeatherService alloc]initWithViewController:self];
}

- (void)viewWillAppear:(BOOL)animated{
    if (current != nil && yesterday != nil && tomorrow != nil){
        [self updateCurrentWeather:current yesterday:yesterday tomorrow:tomorrow];
    }
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
    NSString* yesterdayTempPreposition = @" to";
    if (todayAverage - yesterdayAverage > 3){
        yesterdayTempDescription = @"hotter";
        yesterdayTempPreposition = @" than";
    }else if (todayAverage - yesterdayAverage < -3){
        yesterdayTempDescription = @"cooler";
        yesterdayTempPreposition = @" than";
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
    
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.weatherText.alpha = 1;
        self.buttonView.alpha = 1;
    } completion:^(BOOL finished){
    }];
    
}

@end
