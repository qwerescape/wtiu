//
//  EditController.h
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-05-23.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *editTextBox;
@property (weak, nonatomic) IBOutlet UISwitch *cfSwitch;
- (IBAction)cfValueSwitched:(id)sender;
- (IBAction)donePressed:(id)sender;
@end