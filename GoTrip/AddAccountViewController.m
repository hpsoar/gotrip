//
//  AddActivityViewController.m
//  GoTrip
//
//  Created by Aldrich Huang on 06/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "AddAccountViewController.h"
#import "EditableCell.h"
#import "TripDatabase.h"
#import "TextFieldDelegate.h"

@interface AddAccountViewController ()

@end

@implementation AddAccountViewController
@synthesize trip = _trip;

- (EditableCell *)cellForRow:(NSInteger)row {
    return (EditableCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

- (IBAction)addAccount:(id)sender {
    NSString *title = [self cellForRow:0].valueTextField.text;
    NSNumber *cost = [Utility currencyTextToNumber:[self cellForRow:1].valueTextField.text];
    
    Account *account = [TripDatabase addAccountWithTitle:title withCost:cost toTrip:self.trip];

    [self.delegate addAccountViewController:self didAddAccount:account];
}

- (IBAction)cancel:(id)sender {
    [self.delegate addAccountViewController:self didAddAccount:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EditableCell";
    EditableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    cell.valueTextField.enabled = YES;
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"标题";
        cell.valueTextField.placeholder = @"Eat food";
    }
    else {
        cell.titleLabel.text = @"花费";
        cell.valueTextField.text = @"";
        cell.valueTextField.placeholder = [Utility numberToCurrencyText:nil];
        cell.valueTextField.delegate = [TextFieldDelgates moneyTextFieldDelegate];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
