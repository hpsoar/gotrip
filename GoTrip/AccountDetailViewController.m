//
//  ActivityDetailViewController.m
//  GoTrip
//
//  Created by Aldrich Huang on 07/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "AccountDetailViewController.h"
//#import "ChooseActivityMemberViewController.h"
#import "ChoosePayerViewController.h"
#import "EditableCell.h"
#import "DateInputTableViewCell.h"
#import "Datetime+FormattedString.h"
#import "BillCell.h"
#import "SubAccount.h"
#import "Member.h"
#import "TextFieldDelegate.h"
#import "Utility.h"
#import "TripDatabase.h"

@interface AccountDetailViewController () <DateInputTableViewCellDelegate>
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextField *costTextField;
@property (nonatomic, strong) UITextField *dateTextField;
@property (nonatomic, strong) NSMutableArray *consumptionTextFields;
@end

@implementation AccountDetailViewController
@synthesize account = _account;
@synthesize titleTextField = _titleTextField;
@synthesize costTextField = _costTextField;
@synthesize dateTextField = _dateTextField;
@synthesize consumptionTextFields = _consumptionTextFields;

- (NSMutableArray *)consumptionTextFields {
    if (_consumptionTextFields == nil) {
        _consumptionTextFields = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.account.consumptions.count; ++i)
            [_consumptionTextFields addObject:[NSNull null]];
    }
    return _consumptionTextFields;
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
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.navigationItem.title = self.activity.name;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 1;
        case 2:
            return self.account.consumptions.count;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return nil;
        case 1:
            return @"支付账单";
        case 2:
            return @"消费账单";
        default:
            return nil;
    }
}

- (EditableCell *)editableCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"EditableCell";
    EditableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForBasicInfoSectionAtRow:(NSInteger)row {
    if (row == 2) {
        // TODO: use EditableCell with customized delegate
        static NSString *CellIdentifier = @"DateInputTableViewCell";
        DateInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[DateInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        //cell.valueTextField.enabled = self.editing;
        if (!self.editing) {
        cell.titleLabel.text = @"日期";
        cell.valueTextField.text = [self.account.date toFullDate];
            self.dateTextField = cell.valueTextField;
        }
        return cell;
    }
    else {
        EditableCell *cell = [self editableCellForTableView:tableView];
        cell.valueTextField.enabled = self.editing;
        if (!self.editing) {
        if (row == 0) {
            cell.titleLabel.text = @"标题";
            cell.valueTextField.text = self.account.title;
            self.titleTextField = cell.valueTextField;
        }
        else {
            cell.titleLabel.text = @"花费";
            NSLog(@"---%@, %@", cell.valueTextField.text, self.account.cost);
            cell.valueTextField.text = [Utility numberToCurrencyText: self.account.cost];
            NSLog(@"%@, %@", cell.valueTextField.text, self.account.cost);
            cell.valueTextField.delegate = [TextFieldDelgates moneyTextFieldDelegate];
            self.costTextField = cell.valueTextField;
        }
        }
        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForPayerAtRow:(NSInteger) row {
    EditableCell *cell = [self editableCellForTableView:tableView];
    cell.titleLabel.text = @"付款人";
    cell.valueTextField.text = self.account.payer.name;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForMemberAtRow:(NSInteger)row {
    EditableCell *cell = [self editableCellForTableView:tableView];
    if (!self.editing) {
        SubAccount *consumption = [self.account.consumptions.allObjects objectAtIndex:row];
        cell.titleLabel.text = consumption.owner.name;
        cell.valueTextField.text = [Utility numberToCurrencyText:consumption.amount];
        cell.valueTextField.delegate = [TextFieldDelgates moneyTextFieldDelegate];
        cell.valueTextField.enabled = self.editing;
        [self.consumptionTextFields replaceObjectAtIndex:row withObject:cell.valueTextField];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [self tableView:tableView cellForBasicInfoSectionAtRow:indexPath.row];
        case 1:
            return [self tableView:tableView cellForPayerAtRow:indexPath.row];
        case 2:
            return [self tableView:tableView cellForMemberAtRow:indexPath.row];
        default:
            return nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing) {
        if (indexPath.section == 1)  return indexPath;
        if (indexPath.section == 0 && indexPath.row == 2) return indexPath;
        return nil;
    }
    else {
        if (indexPath.section == 1) return nil;
        if (indexPath.section == 0 && indexPath.row == 2) return nil;
        return indexPath;
    }
}

- (EditableCell *)cellatRow:(NSInteger)row inSection:(NSInteger)section {
    return (EditableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
}

- (void)updateAccountInfo {
    if (self.titleTextField.text.length > 0) self.account.title = self.titleTextField.text;
    self.account.cost = [Utility currencyTextToNumber:self.costTextField.text];
    self.account.date = [Utility fullDateFromString:self.dateTextField.text];

    NSLog(@"date=%@", self.account.date);
}

- (void)updateSubAccounts {
    for (NSInteger i = 0; i < self.account.consumptions.count; ++i) {
        UITextField *textField = [self.consumptionTextFields objectAtIndex:i];
        SubAccount *subAccount = [self.account.consumptions.allObjects objectAtIndex:i];
        subAccount.amount = [Utility currencyTextToNumber:textField.text];
    };
}

- (void)changeCellState {
    [self.tableView beginUpdates];
    EditableCell *cell = [self cellatRow:0 inSection:0];
    cell.valueTextField.enabled = self.editing;
    cell = [self cellatRow:1 inSection:0];
    cell.valueTextField.enabled = self.editing;

    for (NSInteger i = 0; i < self.account.consumptions.count; ++i) {
        EditableCell *cell = [self cellatRow:i inSection:2];
        cell.valueTextField.enabled = self.editing;
    }
    [self.tableView endUpdates];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:YES];
    
    if (!self.editing) {
        [self updateAccountInfo];
        [self updateSubAccounts];
        [[TripDatabase dba] save];
    }
    
    [self changeCellState];
}

static NSString *SegueChoosePayer = @"Choose Account Payer";

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SegueChoosePayer]) {
        ChoosePayerViewController *controller = (ChoosePayerViewController *)segue.destinationViewController;
        controller.account = self.account;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self performSegueWithIdentifier:SegueChoosePayer sender:self];
    }
}

- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value {
    cell.valueTextField.text = [value toFullDate];
}

@end
