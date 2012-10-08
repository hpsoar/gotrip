//
//  AddTripViewController.m
//  GoTrip
//
//  Created by Aldrich Huang on 04/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "AddTripViewController.h"
#import "TripDatabase.h"

@interface AddTripViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation AddTripViewController
@synthesize nameTextField = _nameTextField;
@synthesize delegate = _delegate;

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
    self.navigationItem.title = @"添加旅程";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    
    self.nameTextField.delegate = self;
    [self.nameTextField becomeFirstResponder];
}

- (void)save {
    Trip *trip = [[TripDatabase dba] insertNewObjectForEntityForName:@"Trip"];
    trip.name = self.nameTextField.text;
    trip.startDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    [[TripDatabase dba] save];
    
    [self.delegate addTripViewController:self didAddTrip:trip];
}

- (void)cancel {
    [self.delegate addTripViewController:self didAddTrip:nil];
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [textField resignFirstResponder];
        [self save];
    }
    return YES;
}

@end
