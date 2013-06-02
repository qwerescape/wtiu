//
//  EditController.m
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-05-23.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import "EditController.h"
#import "Weather.h"
@interface EditController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy.gif"]]];
//    
//    //set default celcius ferenheight switch
//    [self.cfSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"isMetric"]];
//    
//    UIColor *normalFontColor=[UIColor colorWithRed:0.306 green:0.306 blue:0.306 alpha:1];
//    UIFont *normalFont=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
//   
//    NSString* userMessage = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_message"];
//    if (userMessage == nil){
//        userMessage = [Weather getDefaultMessageString];
//    }
//    
//    NSMutableAttributedString* message = [[NSMutableAttributedString alloc] initWithString:userMessage];
//
//    [message addAttribute:NSFontAttributeName value:normalFont range:NSMakeRange(0, message.length)];
//    [message addAttribute:NSForegroundColorAttributeName value:normalFontColor range:NSMakeRange(0, message.length)];
//    
//    self.editTextBox.attributedText = message;
//    [self.editTextBox setEditable:YES];
	// Do any additional setup after loading the view.
}

- (IBAction)cfValueSwitched:(id)sender {
    UISwitch* s = (UISwitch*)sender;
    [[NSUserDefaults standardUserDefaults]setBool:s.isOn forKey:@"isMetric"];    
}

- (IBAction)donePressed:(id)sender {
    NSLog(@"yoyoyo");
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //NSString* message = self.editTextBox.attributedText.string;
    //[[NSUserDefaults standardUserDefaults]setObject:message forKey:@"user_message"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
