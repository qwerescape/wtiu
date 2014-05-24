//
//  EditController.h
//  Weather That I Understand
//
//  Created by Chao Qu on 2013-05-23.
//  Copyright (c) 2013 Chao Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenSwitch.h"

@interface EditController : UIViewController{
}
@property (weak, nonatomic) IBOutlet UITextView *editTextBox;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneEditButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *resetButton;
@property (weak, nonatomic) IBOutlet SevenSwitch *cfSwitch;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)doneEditMode:(id)sender;
- (IBAction)cfValueSwitched:(id)sender;
- (IBAction)donePressed:(id)sender;
- (IBAction)resetMessage:(id)sender;
- (IBAction)enterEditMode:(id)sender;
@end