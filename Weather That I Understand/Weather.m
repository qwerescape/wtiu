//
//  Weather.m
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-04-26.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import "Weather.h"

@implementation Weather
-(id)init{
    if (self = [super init]){
        self.wc = @"a fine day";
    }
    return self;
}
+(NSString*)getDefaultMessageString{
    return @"You are in {city}, beautiful. "
    "My sources say today is {today_forecast}, "
    "which is {hotter_colder} yesterday's {yesterday_forecast}. "
    "Currently it feels like {current_temp}. "
    "Overall today it'll be {weather_cond}. "
    "It is {wind_cond}, {wind_speed}.";
}
@end
