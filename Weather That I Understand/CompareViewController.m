//
//  CompareViewController.m
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-05-07.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import "CompareViewController.h"

@interface CompareViewController ()

@end

@implementation CompareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIFont *specialFont=[UIFont fontWithName:@"Helvetica" size:25.0f];
    UIColor *normalFontColor=[UIColor colorWithRed:0.251 green:0.251 blue:0.251 alpha:1];
    UIFont *normalFont=[UIFont fontWithName:@"Helvetica" size:16.0f];
    


    NSString* fillerText = [NSString stringWithFormat:
                            @"You you're in {1}...nice. \n"
                             "Today's temperature is {2}, it is obviously in %@ because who uses %@? Today is {3} %@ yesterday's %@. Currently it feels like {4}, {5} and {6}", @"Ferenheight", @"Celcius", @"than", @"24/9"];
    NSMutableAttributedString* attrFillerText = [[NSMutableAttributedString alloc] initWithString:fillerText];
    
    [attrFillerText addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, attrFillerText.length)];
    [attrFillerText addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, attrFillerText.length)];
    
    NSMutableAttributedString* cityName = [[NSMutableAttributedString alloc] initWithString:@"Toronto"];
    
    [cityName addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, cityName.length)];
    [cityName addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, cityName.length)];
    
    [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{1}"] withAttributedString:cityName];
    
    NSMutableAttributedString* todayForecastTemp = [[NSMutableAttributedString alloc] initWithString:@"25/7"];
    [todayForecastTemp addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, todayForecastTemp.length)];
    [todayForecastTemp addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, todayForecastTemp.length)];
    [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{2}"] withAttributedString:todayForecastTemp];
    
    NSMutableAttributedString* yesterdayCompare = [[NSMutableAttributedString alloc] initWithString:@"Hotter"];
    [yesterdayCompare addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, yesterdayCompare.length)];
    [yesterdayCompare addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, yesterdayCompare.length)];
    [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{3}"] withAttributedString:yesterdayCompare];
    
    
    NSMutableAttributedString* currentTemp = [[NSMutableAttributedString alloc] initWithString:@"24"];
    [currentTemp addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, currentTemp.length)];
    [currentTemp addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, currentTemp.length)];
    [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{4}"] withAttributedString:currentTemp];
    
    NSMutableAttributedString* currentWeather = [[NSMutableAttributedString alloc] initWithString:@"mostly cloudy"];
    [currentWeather addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, currentWeather.length)];
    [currentWeather addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, currentWeather.length)];
    [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{5}"] withAttributedString:currentWeather];
    
    NSMutableAttributedString* currentWind = [[NSMutableAttributedString alloc] initWithString:@"not windy"];
    [currentWind addAttribute:NSFontAttributeName value:specialFont range:NSMakeRange(0, currentWind.length)];
    [currentWind addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, currentWind.length)];
    [attrFillerText replaceCharactersInRange:[attrFillerText.string rangeOfString:@"{6}"] withAttributedString:currentWind];
    
    self.weatherText.attributedText = attrFillerText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
