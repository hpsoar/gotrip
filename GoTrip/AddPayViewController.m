//
//  ViewController.m
//  GoTrip
//
//  Created by Aldrich Huang on 04/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "AddPayViewController.h"
#import "TripDatabase.h"

@interface AddPayViewController () <UITextFieldDelegate>

@end

@implementation AddPayViewController
@synthesize amountTextField;
@synthesize titleLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addPay)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.titleLabel.text = [NSString stringWithFormat:@"%@为%@付了", self.member.name, self.activity.name];
    self.amountTextField.text = [NSString stringWithFormat:@"￥%@", [TripDatabase costRemainForActivity:self.activity]];
    self.amountTextField.delegate = self;
    [self.amountTextField becomeFirstResponder];
}

- (void)addPay {
    [TripDatabase addPay:[NSNumber numberWithFloat:self.amountTextField.text.floatValue] byMember:self.member forActivity:self.activity];
    [[TripDatabase dba] save];

    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancel {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setAmountTextField:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self addPay];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.amountTextField.text = [self.amountTextField.text substringFromIndex:1];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.amountTextField.text = [NSString stringWithFormat:@"￥%@", self.amountTextField.text];
    return YES;
}

@end
