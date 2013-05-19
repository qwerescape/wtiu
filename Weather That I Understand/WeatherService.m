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
-(void)getCurrentWeatherData:(NSMutableData*)receivedData;
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
    NSURLRequest *currentWeatherRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/655b22ba986882f1/yesterday/forecast/conditions/q/%f,%f.json", lat, lng]]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:30.0];
    [[[WeatherServiceDelegate alloc]initWithRequest:currentWeatherRequest]startConnection:^(NSMutableData*data){
        [self getCurrentWeatherData: data];
    } progress:^(float progress){
        [viewController.loader setProgress:progress];
    }];
}

-(void)getCurrentWeatherData:(NSMutableData*)receivedData{
    lastReceivedData = receivedData;
    NSError* e;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData: receivedData
                                                             options: NSJSONReadingMutableContainers
                                                               error: &e];
    
    //current city
    NSString* city = [[[jsonData objectForKey:@"current_observation"] objectForKey:@"display_location"]objectForKey:@"city"];
    [viewController updateCityName:city];
    
    double currentTempc = [[[jsonData objectForKey:@"current_observation"]objectForKey:@"feelslike_c"]doubleValue];
    double currentTempf = [[[jsonData objectForKey:@"current_observation"]objectForKey:@"feelslike_f"]doubleValue];
    
    //current temperature
    NSArray* forecast = [[[jsonData objectForKey:@"forecast"]objectForKey:@"simpleforecast"]objectForKey:@"forecastday"];
    
    NSDictionary* current = [forecast objectAtIndex:0];
    double current_high = [[[current objectForKey:@"high"]objectForKey:@"celsius"]doubleValue];
    double current_low = [[[current objectForKey:@"low"]objectForKey:@"celsius"]doubleValue];
    double current_wind = [[[current objectForKey:@"avewind"]objectForKey:@"kph"]doubleValue];
    
    double current_highf = [[[current objectForKey:@"high"]objectForKey:@"fahrenheit"]doubleValue];
    double current_lowf = [[[current objectForKey:@"low"]objectForKey:@"fahrenheit"]doubleValue];
    double current_windf = [[[current objectForKey:@"avewind"]objectForKey:@"mph"]doubleValue];

    Weather* w = [[Weather alloc]init];
    w.chigh = current_high;
    w.clow = current_low;
    w.cwind = current_wind;
    w.fhigh = current_highf;
    w.flow = current_lowf;
    w.fwind = current_windf;
    w.cfeelLike = currentTempc;
    w.ffeelslike = currentTempf;
    
    //weather condition
    NSString* weatherCond = [current objectForKey:@"conditions"];
    w.wc = weatherCond;
    
    //yesterday weather
    NSDictionary* yesterday = [[[jsonData objectForKey:@"history"]objectForKey:@"dailysummary"] objectAtIndex:0];
    double y_high = [[yesterday objectForKey:@"maxtempm"]doubleValue];
    double y_low = [[yesterday objectForKey:@"mintempm"]doubleValue];
    double y_highf = [[yesterday objectForKey:@"maxtempi"]doubleValue];
    double y_lowf = [[yesterday objectForKey:@"mintempi"]doubleValue];
    Weather* yw = [[Weather alloc]init];
    yw.chigh = y_high;
    yw.clow = y_low;
    yw.fhigh = y_highf;
    yw.flow = y_lowf;
    
    //tomorrow weather;
    NSDictionary* tomorrow = [forecast objectAtIndex:1];
    double t_high = [[[tomorrow objectForKey:@"high"]objectForKey:@"celsius"]doubleValue];
    double t_low = [[[tomorrow objectForKey:@"low"]objectForKey:@"celsius"]doubleValue];
    double t_highf = [[[tomorrow objectForKey:@"high"]objectForKey:@"fahrenheit"]doubleValue];
    double t_lowf = [[[tomorrow objectForKey:@"low"]objectForKey:@"fahrenheit"]doubleValue];
    Weather* tw = [[Weather alloc]init];
    tw.chigh = t_high;
    tw.clow = t_low;
    tw.fhigh = t_highf;
    tw.flow = t_lowf;
    
    [viewController updateCurrentWeather:w yesterday:yw tomorrow:tw];
}
@end
