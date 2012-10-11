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
#import "ConsumptionCell.h"
#import "DateInputTableViewCell.h"
#import "Datetime+FormattedString.h"
#import "SubAccount.h"
#import "Member.h"
#import "TextFieldDelegate.h"
#import "Utility.h"
#import "TripDatabase.h"

@interface AccountDetailViewController () <DateInputTableViewCellDelegate, UITextFieldDelegate, ConsumptionStateDelegate>
@property (nonatomic, strong) UITextField *currentTextField;
@end

@implementation AccountDetailViewController
@synthesize account = _account;
@synthesize currentTextField = _currentTextField;

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
    self.editButtonItem.title = @"编辑";
    //self.navigationItem.title = self.activity.name;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.currentTextField resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
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
            return nil; //@"支付账单";
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
        cell.valueTextField.delegate = self;
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
            cell.valueTextField.delegate = self;
        }
        
        cell.titleLabel.text = @"日期";
        cell.valueTextField.text = [self.account.date toFullDate];
        cell.datePicker.date = self.account.date;
        cell.valueTextField.tag = -1;
        cell.delegate = self;

        return cell;
    }
    else {
        EditableCell *cell = [self editableCellForTableView:tableView];
        cell.valueTextField.enabled = self.editing;
        if (row == 0) {
            cell.titleLabel.text = @"标题";
            cell.valueTextField.text = self.account.title;
            cell.valueTextField.tag = -3;
        }
        else {
            cell.titleLabel.text = @"花费";
            cell.valueTextField.text = [Utility numberToCurrencyText: self.account.cost];
            cell.valueTextField.tag = -2;
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
    static NSString *CellIdentifier = @"ConsumptionCell";
    ConsumptionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    SubAccount *consumption = [self.account.consumptions.allObjects objectAtIndex:row];
    cell.titleLabel.text = consumption.owner.name;
    cell.valueTextField.text = [Utility numberToCurrencyText:consumption.amount];
    cell.valueTextField.enabled = self.editing;
    cell.valueTextField.tag = row;
    cell.valueTextField.delegate = self;
    //cell.valueTextField.returnKeyType = UIReturnKeyDone;
    cell.delegate = self;
    cell.consumptionStateButton.enabled = self.editing;
    
    [self updateConsumptionStateButton:cell.consumptionStateButton toState:consumption.isAA];
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

- (void)changeCellState {
    [self.tableView beginUpdates];
    EditableCell *cell = [self cellatRow:0 inSection:0];
    cell.valueTextField.enabled = self.editing;
    cell = [self cellatRow:1 inSection:0];
    cell.valueTextField.enabled = self.editing;

    for (NSInteger i = 0; i < self.account.consumptions.count; ++i) {
        ConsumptionCell *cell = (ConsumptionCell *)[self cellatRow:i inSection:2];
        cell.valueTextField.enabled = self.editing;
        cell.consumptionStateButton.enabled = self.editing;
    }
    [self.tableView endUpdates];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    //[self.navigationItem setHidesBackButton:editing animated:YES];
    self.editButtonItem.title = self.editing ? @"完成" : @"编辑";
    
    if (!self.editing) {
        [self.currentTextField resignFirstResponder];
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
        [self.currentTextField resignFirstResponder];
        [self performSegueWithIdentifier:SegueChoosePayer sender:self];
    }
}

- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value {
    //cell.valueTextField.text = [value toFullDate];
    self.account.date = value;
    [[TripDatabase dba] save];
}

- (void)updateConsumptionStateButton:(UIButton *)button toState:(NSNumber *)state {
    UIColor *color = state.boolValue ? [UIColor blueColor] : [UIColor grayColor];
    [button setTitleColor:color forState:UIControlStateNormal];
}

- (void)consumptionStateButtonChanged:(UIButton *)button {
    SubAccount *consumption = [self.account.consumptions.allObjects objectAtIndex:button.tag];
    consumption.isAA = [NSNumber numberWithBool:!consumption.isAA.boolValue];
    
    [self updateConsumptionStateButton:button toState:consumption.isAA];
    [TripDatabase updateConsumptionForAccount:self.account];
    [[TripDatabase dba] save];
    [self updateConsumptionView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag < 0) {
        switch (textField.tag) {
            case -3:
                if (textField.text.length > 0) self.account.title = textField.text;
                break;
            case -2:
                self.account.cost = [Utility currencyTextToNumber:textField.text];
                break;
            case -1:
                // TODO: this is of no use
                self.account.date = [Utility fullDateFromString:textField.text];
                break;
            default:
                break;
        }
    }
    else {
        SubAccount *subaccount = [self.account.consumptions.allObjects objectAtIndex:textField.tag];
        subaccount.amount = [Utility currencyTextToNumber:textField.text];
        subaccount.isAA = [NSNumber numberWithBool:NO]; // once a subaccount is editted manully, it's no a aa subaccount anymore
        
        ConsumptionCell *cell = (ConsumptionCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:2]];
        [self updateConsumptionStateButton:cell.consumptionStateButton toState:subaccount.isAA];
        [TripDatabase updateConsumptionForAccount:self.account];
        [self updateConsumptionView];
    }
    [[TripDatabase dba] save];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == -2 || textField.tag >= 0)
    textField.text = [Utility currencyTextToNumberText:textField.text];
    return YES;
}

- (void)updateConsumptionView {
    // TODO: the following is bad
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView beginUpdates];
    for (NSInteger i = 0; i < self.account.consumptions.count; ++i) {
        ConsumptionCell *cell = (ConsumptionCell *)[self cellatRow:i inSection:2];
        cell.valueTextField.enabled = self.editing;
        cell.consumptionStateButton.enabled = self.editing;
        SubAccount *subaccount = [self.account.consumptions.allObjects objectAtIndex:i];
        cell.valueTextField.text = [Utility numberToCurrencyText:subaccount.amount];
    }
    [self.tableView endUpdates];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.tag == -2 || textField.tag >= 0)
    textField.text = [Utility numberTextToCurrencyText:textField.text];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
