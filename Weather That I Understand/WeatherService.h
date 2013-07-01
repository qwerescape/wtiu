//
//  WeatherService.h
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-04-19.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ViewController;
@class Weather;
@interface WeatherService : NSObject{
    ViewController* viewController;
    Weather* yesterdayWeather;
    Weather* todayWeather;
}
-(id)initWithViewController: (ViewController*)vc;
-(void)getCurrentWeatherForLatitude:(double)lat longitude:(double)lng;
@end
