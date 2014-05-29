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
#import "SyntaxHighlightTextStorage.h"
@interface EditController ()
- (void)keyboardWillShow:(NSNotification*)notification;
@end

@implementation EditController{
    SyntaxHighlightTextStorage * myTextStorage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    self.cfSwitch.onTintColor = [UIColor clearColor];
    self.cfSwitch.isRounded = NO;
    
    NSString* userMessage = [[NSUserDefaults standardUserDefaults]stringForKey:@"user_message"];
    if (userMessage == nil){
        userMessage = [Weather getDefaultMessageString];
    }
//    [self highlightKeywords:userMessage];
    myTextStorage = [SyntaxHighlightTextStorage new];
    [myTextStorage addLayoutManager:self.editTextBox.layoutManager];
    [myTextStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:userMessage];
//    self.editTextBox.text = userMessage;
    
    NSMutableArray* toolBarItems = [self.toolBar.items mutableCopy];
    [toolBarItems removeObject:self.doneEditButton];
    [toolBarItems removeObject:self.resetButton];
    [self.toolBar setItems:[toolBarItems copy]];
    
    [self.toolBar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 200.0, 0.0);
    self.editTextBox.contentInset= contentInsets;
    self.editTextBox.textContainerInset = UIEdgeInsetsMake(5.0, 5.0, 0.0, 5.0);
    self.editTextBox.scrollIndicatorInsets = contentInsets;
}

-(void)viewWillAppear:(BOOL)animated{
    // Register notifications for when the keyboard appears
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSLog(@"keyboard will show");
   
    
    double delayInMiliSeconds = 200.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInMiliSeconds * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        CGRect caretRect = [self.editTextBox caretRectForPosition:self.editTextBox.selectedTextRange.end];
        NSLog(@"caretRect: %f,%f", caretRect.origin.y, caretRect.size.height);
        [self.editTextBox scrollRectToVisible:caretRect animated:YES];
    });
}


- (void)textViewShouldBeginEditing:(UITextView *)textView{
    NSMutableArray* toolBarItems = [self.toolBar.items mutableCopy];
    [toolBarItems addObject:self.doneEditButton];
    [toolBarItems addObject:self.resetButton];
    [toolBarItems removeObject:self.editButton];
    [self.toolBar setItems:toolBarItems animated:YES];
}

- (void)textViewShouldEndEditing:(UITextView *)textView{
    NSMutableArray* toolBarItems = [self.toolBar.items mutableCopy];
    [toolBarItems removeObject:self.doneEditButton];
    [toolBarItems removeObject:self.resetButton];
    [toolBarItems addObject:self.editButton];
    [self.toolBar setItems:toolBarItems animated:YES];
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
    CGRect caretRect = [textView caretRectForPosition:textView.selectedTextRange.end];
    [textView scrollRectToVisible:caretRect animated:YES];
    
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

- (IBAction)enterEditMode:(id)sender {
    [self.editTextBox becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneEditMode:(id)sender {
    NSString* message = self.editTextBox.attributedText.string;
    [[NSUserDefaults standardUserDefaults]setObject:message forKey:@"user_message"];
    [self.editTextBox endEditing:NO];
}
@end
