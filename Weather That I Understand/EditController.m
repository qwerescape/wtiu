//
//  EditController.m
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-05-23.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import "EditController.h"
#import "Weather.h"
#import <QuartzCore/QuartzCore.h>
@interface EditController ()
-(void)keyboardWillShow:(NSNotification*)notification;
-(void)keyboardWillHide:(NSNotification*)notification;
-(void)moveTextViewForKeyboard:(NSNotification*)notification up:(BOOL)up;
@end

@implementation EditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)highlightKeywords:(NSString*)userMessage
{
    UIColor *normalFontColor=[UIColor colorWithRed:0.306 green:0.306 blue:0.306 alpha:1];
    UIFont *normalFont=[UIFont fontWithName:@"HelveticaNeue-Light" size:21.0f];
    UIColor *specialFontColor=[UIColor colorWithRed:0.87 green:0.352 blue:0.371 alpha:1];
        
    NSMutableAttributedString* message = [[NSMutableAttributedString alloc] initWithString:userMessage];
    
    [message addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, message.length)];
    [message addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, message.length)];

    //highlight the text
    NSArray* keywords = [NSArray arrayWithObjects:@"{city}",@"{today_forecast}",@"{hotter_colder}",@"{yesterday_forecast}",@"{current_temp}",@"{weather_cond}",@"{wind_cond}",@"{wind_speed}", nil];
    for (NSString* keyword in keywords){
        if ([message.string rangeOfString:keyword].location != NSNotFound){
            NSMutableAttributedString* attributedKeyword = [[NSMutableAttributedString alloc] initWithString:keyword];
            [attributedKeyword addAttribute:NSForegroundColorAttributeName value:specialFontColor range:NSMakeRange(0, attributedKeyword.length)];
            [attributedKeyword addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, attributedKeyword.length)];
            [message replaceCharactersInRange:[message.string rangeOfString:keyword] withAttributedString:attributedKeyword];
        }
    }    
    self.editTextBox.attributedText = message;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy.gif"]]];
    
    //set default celcius ferenheight switch
    [self.cfSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"isMetric"]];
    self.cfSwitch.onImage = [UIImage imageNamed:@"c.png"];
    self.cfSwitch.offImage = [UIImage imageNamed:@"f.png"];
    self.cfSwitch.onTintColor = [UIColor colorWithRed:0.87 green:0.352 blue:0.371 alpha:1];
    self.cfSwitch.isRounded = NO;
    
    self.editTextBox.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.editTextBox.clipsToBounds = YES;
    
    NSString* userMessage = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_message"];
    if (userMessage == nil){
        userMessage = [Weather getDefaultMessageString];
    }
   
    [self highlightKeywords:userMessage];
}

-(void)viewWillAppear:(BOOL)animated{
    // Register notifications for when the keyboard appears
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)moveTextViewForKeyboard:(NSNotification*)notification up:(BOOL)up {
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (up == YES) {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        self.editTextBox.contentInset = contentInsets;
        self.editTextBox.scrollIndicatorInsets = contentInsets;
        //scroll cursor into view?
    } else {
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.editTextBox.contentInset = contentInsets;
        self.editTextBox.scrollIndicatorInsets = contentInsets;
    }
    
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    [self moveTextViewForKeyboard:notification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    [self moveTextViewForKeyboard:notification up:NO];
}

- (IBAction)cfValueSwitched:(id)sender {
    UISwitch* s = (UISwitch*)sender;
    [[NSUserDefaults standardUserDefaults]setBool:s.isOn forKey:@"isMetric"];    
}

- (IBAction)donePressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetMessage:(id)sender {
   NSString* userMessage = [Weather getDefaultMessageString];
    [self highlightKeywords:userMessage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString* message = self.editTextBox.attributedText.string;
    [[NSUserDefaults standardUserDefaults]setObject:message forKey:@"user_message"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
