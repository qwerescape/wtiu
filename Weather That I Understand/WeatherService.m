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
@interface WeatherService()
-(void)getCurrentWeatherData:(NSMutableData*)receivedData;
-(void)getYesterdayWeatherData:(NSMutableData*)receivedData;
@end
@implementation WeatherService
-(id)initWithViewController:(ViewController *)vc{
    if (self = [super init]){
        viewController = vc;
    }
    return self;
}

-(void)getYesterdayWeatherForLatitude:(double)lat longitude:(double)lng{
    NSURLRequest *yeterdayWeatherRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/655b22ba986882f1/yesterday/q/%f,%f.json", lat, lng]]
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                      timeoutInterval:30.0];
    [[[WeatherServiceDelegate alloc]initWithRequest:yeterdayWeatherRequest]startConnection:^(NSMutableData* data){
        [self getYesterdayWeatherData: data];
    }];
}

-(void)getCurrentWeatherForLatitude:(double)lat longitude:(double)lng{
    // Create the request.
    NSURLRequest *currentWeatherRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/655b22ba986882f1/geolookup/conditions/q/%f,%f.json", lat, lng]]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:30.0];
    [[[WeatherServiceDelegate alloc]initWithRequest:currentWeatherRequest]startConnection:^(NSMutableData*data){
        [self getCurrentWeatherData: data];
    }];}

-(void)getYesterdayWeatherData:(NSMutableData*)receivedData{
    NSError* e;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData: receivedData
                                                             options: NSJSONReadingMutableContainers
                                                               error: &e];
    NSDictionary* history = [jsonData objectForKey:@"history"];
    NSDictionary* dailySummary = [history objectForKey:@"dailysummary"];
    [viewController.technicalWeatherCondition setText:[dailySummary description]];
}

-(void)getCurrentWeatherData:(NSMutableData*)receivedData{
    NSError* e;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData: receivedData
                                                             options: NSJSONReadingMutableContainers
                                                               error: &e];
    NSDictionary* current = [jsonData objectForKey:@"current_observation"];
    NSString* city = [[current objectForKey:@"display_location"]objectForKey:@"city"];
    NSDictionary* weather = [current objectForKey:@"weather"];
    [viewController updateCityName:city];
    //[viewController.technicalWeatherCondition setText:[weather description]];
}
@end
