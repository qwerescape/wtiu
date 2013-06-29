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
    UIFont *normalFont=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
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
    self.cfSwitch.onImage = [UIImage imageNamed:@"celcius.png"];
    self.cfSwitch.offImage = [UIImage imageNamed:@"ferenheight.png"];
    
    NSString* userMessage = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_message"];
    if (userMessage == nil){
        userMessage = [Weather getDefaultMessageString];
    }
   
    [self highlightKeywords:userMessage];
    self.editTextBox.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.editTextBox.layer.cornerRadius = 10.0;
    self.editTextBox.clipsToBounds = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    // Register notifications for when the keyboard appears
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    CGRect frame = self.editTextBox.frame;
    frame.size.height = self.editTextBox.contentSize.height;
    self.editTextBox.frame = frame;
}

-(void)moveTextViewForKeyboard:(NSNotification*)notification up:(BOOL)up {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardRect;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (up == YES) {
        CGFloat keyboardTop = keyboardRect.origin.y;
        CGRect newTextViewFrame = self.editTextBox.frame;
        originalTextViewFrame = self.editTextBox.frame;
        newTextViewFrame.size.height = keyboardTop - self.editTextBox.frame.origin.y;
        
        self.editTextBox.frame = newTextViewFrame;
    } else {
        // Keyboard is going away (down) - restore original frame
        self.editTextBox.frame = originalTextViewFrame;
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

- (IBAction)closeKeyboard:(id)sender {
    [self.editTextBox endEditing:YES];
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
