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
-(void)refresh;
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

    UIFont *specialFont=[UIFont fontWithName:@"HelveticaNeue-Light" size:21.0f];
    UIColor *specialFontColor=[UIColor colorWithRed:0.87 green:0.352 blue:0.371 alpha:1];
//    UIColor *normalFontColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    UIColor *normalFontColor=[UIColor colorWithRed:0.306 green:0.306 blue:0.306 alpha:1];
    UIFont *normalFont=[UIFont fontWithName:@"HelveticaNeue-Light" size:21.0f];
    
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
        [cityName addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:NSMakeRange(0,cityName.length)];
        
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
    [style setLineSpacing:8];
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
	weatherService = [[WeatherService alloc]initWithViewController:self];
    current = nil;
    yesterday = nil;
    [self refresh];
}

- (void) refresh{
    //if current and yesterday weathers are nil or if the data is too old
    if (self.isViewLoaded && self.view.window){
        if (current == nil || yesterday == nil || lastLoadedDate == nil || [lastLoadedDate timeIntervalSinceNow] < -3600){
            self.weatherText.alpha = 0;
            self.buttonView.alpha = 0;
            [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
            [self.loadingLabel setText:@"Locating you..."];
            self.loadingLabel.alpha = 1;
            lastLoadedDate = [NSDate date];
            [locationManager startUpdatingLocation];
        }else if (current != nil && yesterday != nil){
            [self updateCurrentWeather:current yesterday:yesterday tomorrow:nil];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear");
    [super viewWillAppear:animated];
    self.weatherText.alpha = 0;
    self.buttonView.alpha = 0;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(refresh)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"view did appear");
    [super viewDidAppear:animated];
    [self refresh];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"view will disappear");
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"located");
    [locationManager stopUpdatingLocation];
    CLLocation* firstLocation = [locations objectAtIndex:0];
    double lat = [firstLocation coordinate].latitude;
    double lng = [firstLocation coordinate].longitude;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:firstLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           currentCity = @"in a place off the map";                           
                       }
                       
                       if(placemarks && placemarks.count > 0)
                       {
                           //do something
                           CLPlacemark *topResult = [placemarks objectAtIndex:0];
                           currentCity = [topResult locality];
                       }else{
                           currentCity = @"in a place off the map";
                       }
                       [self. loadingLabel setText:@"Getting weather data..."];
                       [weatherService getCurrentWeatherForLatitude:lat longitude:lng];
                   }];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError: (NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Please enable location service in Settings -> Privacy and restart this app";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    [self.loadingLabel setTextAlignment:NSTextAlignmentLeft];
    [self.loadingLabel setText:errorString];
}

-(void)setProgress:(float)progress{
    //[self.loadingLabel setText:[NSString stringWithFormat:@"%f%%", progress]];
}

-(void)updateCityName:(NSString *)name{
    currentCity = name;
}

-(void)updateCurrentWeather:(Weather *)cw yesterday:(Weather *)yw tomorrow:(Weather *)tw{
    current = cw;
    yesterday = yw;
    
    double currentFeelsLike = cw.cfeelLike;
    double currentHigh = cw.chigh;
    double currentLow = cw.clow;
    double currentWind = cw.cwind;
    
    double yesterdayHigh = yw.chigh;
    double yesterdayLow = yw.clow;
    
    NSString* windUnit = @"km/h";
    
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
    
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isMetric"]){
        currentFeelsLike = cw.ffeelslike;
        currentHigh = cw.fhigh;
        currentLow = cw.flow;
        currentWind = cw.fwind;
        
        yesterdayHigh = yw.fhigh;
        yesterdayLow = yw.flow;
        
        windUnit = @"miles/h";
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
    
    self.loadingLabel.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.weatherText.alpha = 1;
        self.buttonView.alpha = 1;
    } completion:^(BOOL finished){
    }];
    
}

@end
