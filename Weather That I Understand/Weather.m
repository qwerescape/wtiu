//
//  Weather.m
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-04-26.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import "Weather.h"

@implementation Weather
+(NSString*)getDefaultMessageString{
    return @"You are in {city}, beautiful. "
    "My sources say today is {today_forecast}, "
    "which is {hotter_colder} yesterday's {yesterday_forecast}. "
    "Currently it feels like {current_temp}. "
    "Overall today it'll be {weather_cond}, "
    "and it is {wind_cond}, {wind_speed}.";
}
@end
