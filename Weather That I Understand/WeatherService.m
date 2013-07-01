//
//  WeatherService.m
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-04-19.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import "WeatherService.h"
#import "ViewController.h"
#import "WeatherServiceDelegate.h"
#import "Weather.h"
@interface WeatherService()
//-(void)getCurrentWeatherData:(NSMutableData*)receivedData;
-(void)getYesterdayWeatherData:(NSMutableData*)receivedData;
-(void)updateWeather;
@end
@implementation WeatherService
-(id)initWithViewController:(ViewController *)vc{
    if (self = [super init]){
        viewController = vc;
    }
    return self;
}

-(void)getCurrentWeatherForLatitude:(double)lat longitude:(double)lng{
    // Create the request.
    todayWeather = nil;
    yesterdayWeather = nil;
    //weather underground url
    //http://api.wunderground.com/api/655b22ba986882f1/yesterday/forecast/conditions/q/%f,%f.json
    
    
    NSURLRequest *currentWeatherRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/272c50e5cbaead39cdaa744c9a2d69e9/%f,%f", lat, lng]]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:30.0];
    [[[WeatherServiceDelegate alloc]initWithRequest:currentWeatherRequest]startConnection:^(NSMutableData*data){
        [self getTodayWeatherData: data];
    } progress:^(float progress){
        [viewController setProgress:progress];
    }];
    
    //get yesterday
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];

    
    NSURLRequest *yesterdayWeatherRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/272c50e5cbaead39cdaa744c9a2d69e9/%f,%f,%ld", lat, lng, (long)[yesterday timeIntervalSince1970]]]
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:30.0];
    [[[WeatherServiceDelegate alloc]initWithRequest:yesterdayWeatherRequest]startConnection:^(NSMutableData*data){
        [self getYesterdayWeatherData: data];
    } progress:^(float progress){
        [viewController setProgress:progress];
    }];
}

-(void)getYesterdayWeatherData:(NSMutableData *)receivedData{
    NSError* e;
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:&e];
    NSArray* dailyDataArray = [[jsonData objectForKey:@"daily"]objectForKey:@"data"];
    NSDictionary* yesterday = [dailyDataArray objectAtIndex:0];
    double temp_min = [[yesterday objectForKey:@"temperatureMin"]doubleValue];
    double temp_max = [[yesterday objectForKey:@"temperatureMax"]doubleValue];
    yesterdayWeather = [[Weather alloc]init];
    yesterdayWeather.chigh = (5.0/9.0) * (temp_max-32);
    yesterdayWeather.clow = (5.0/9.0) * (temp_min-32);
    yesterdayWeather.fhigh = temp_max;
    yesterdayWeather.flow = temp_min;
    [self updateWeather];
}


-(void)getTodayWeatherData:(NSMutableData *)receivedData{
    NSError* e;
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:&e];
    
    //daily forecast
    NSArray* dailyDataArray = [[jsonData objectForKey:@"daily"]objectForKey:@"data"];
    NSDictionary* today = [dailyDataArray objectAtIndex:0];
    double temp_min = [[today objectForKey:@"temperatureMin"]doubleValue];
    double temp_max = [[today objectForKey:@"temperatureMax"]doubleValue];
    todayWeather = [[Weather alloc]init];
    todayWeather.chigh = (5.0/9.0) * (temp_max-32);
    todayWeather.clow = (5.0/9.0) * (temp_min-32);
    todayWeather.fhigh = temp_max;
    todayWeather.flow = temp_min;
    
    //get current weather
    double currentTemp = [[[jsonData objectForKey:@"currently"]objectForKey:@"temperature"]doubleValue];
    double windSpeed = [[[jsonData objectForKey:@"currently"]objectForKey:@"windSpeed"]doubleValue];
    NSString* weatherCond = [today objectForKey:@"summary"];
    if ([weatherCond characterAtIndex:weatherCond.length - 1] == '.'){
        weatherCond = [weatherCond substringToIndex:weatherCond.length - 1];
    }
    todayWeather.wc = weatherCond;
    todayWeather.cfeelLike = (5.0/9.0) * (currentTemp-32);
    todayWeather.ffeelslike = currentTemp;
    todayWeather.fwind = windSpeed;
    todayWeather.cwind = windSpeed/1.61;
    [self updateWeather];
    
}

-(void)updateWeather{
    if (todayWeather != nil && yesterdayWeather != nil){
        [viewController updateCurrentWeather:todayWeather yesterday:yesterdayWeather tomorrow:nil];
    }
}

//-(void)getCurrentWeatherData:(NSMutableData*)receivedData{
//    NSError* e;
//    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData: receivedData
//                                                             options: NSJSONReadingMutableContainers
//                                                               error: &e];
//    
//    //current city
//    NSString* city = [[[jsonData objectForKey:@"current_observation"] objectForKey:@"display_location"]objectForKey:@"city"];
//    [viewController updateCityName:city];
//    
//    double currentTempc = [[[jsonData objectForKey:@"current_observation"]objectForKey:@"feelslike_c"]doubleValue];
//    double currentTempf = [[[jsonData objectForKey:@"current_observation"]objectForKey:@"feelslike_f"]doubleValue];
//    
//    //current temperature
//    NSArray* forecast = [[[jsonData objectForKey:@"forecast"]objectForKey:@"simpleforecast"]objectForKey:@"forecastday"];
//    
//    NSDictionary* current = [forecast objectAtIndex:0];
//    double current_high = [[[current objectForKey:@"high"]objectForKey:@"celsius"]doubleValue];
//    double current_low = [[[current objectForKey:@"low"]objectForKey:@"celsius"]doubleValue];
//    double current_wind = [[[current objectForKey:@"avewind"]objectForKey:@"kph"]doubleValue];
//    
//    double current_highf = [[[current objectForKey:@"high"]objectForKey:@"fahrenheit"]doubleValue];
//    double current_lowf = [[[current objectForKey:@"low"]objectForKey:@"fahrenheit"]doubleValue];
//    double current_windf = [[[current objectForKey:@"avewind"]objectForKey:@"mph"]doubleValue];
//
//    Weather* w = [[Weather alloc]init];
//    w.chigh = current_high;
//    w.clow = current_low;
//    w.cwind = current_wind;
//    w.fhigh = current_highf;
//    w.flow = current_lowf;
//    w.fwind = current_windf;
//    w.cfeelLike = currentTempc;
//    w.ffeelslike = currentTempf;
//    
//    //weather condition
//    NSString* weatherCond = [current objectForKey:@"conditions"];
//    w.wc = weatherCond;
//    
//    //yesterday weather
//    NSDictionary* yesterday = [[[jsonData objectForKey:@"history"]objectForKey:@"dailysummary"] objectAtIndex:0];
//    double y_high = [[yesterday objectForKey:@"maxtempm"]doubleValue];
//    double y_low = [[yesterday objectForKey:@"mintempm"]doubleValue];
//    double y_highf = [[yesterday objectForKey:@"maxtempi"]doubleValue];
//    double y_lowf = [[yesterday objectForKey:@"mintempi"]doubleValue];
//    Weather* yw = [[Weather alloc]init];
//    yw.chigh = y_high;
//    yw.clow = y_low;
//    yw.fhigh = y_highf;
//    yw.flow = y_lowf;
//    
//    //tomorrow weather;
//    NSDictionary* tomorrow = [forecast objectAtIndex:1];
//    double t_high = [[[tomorrow objectForKey:@"high"]objectForKey:@"celsius"]doubleValue];
//    double t_low = [[[tomorrow objectForKey:@"low"]objectForKey:@"celsius"]doubleValue];
//    double t_highf = [[[tomorrow objectForKey:@"high"]objectForKey:@"fahrenheit"]doubleValue];
//    double t_lowf = [[[tomorrow objectForKey:@"low"]objectForKey:@"fahrenheit"]doubleValue];
//    Weather* tw = [[Weather alloc]init];
//    tw.chigh = t_high;
//    tw.clow = t_low;
//    tw.fhigh = t_highf;
//    tw.flow = t_lowf;
//    
//    [viewController updateCurrentWeather:w yesterday:yw tomorrow:tw];
//}
@end
