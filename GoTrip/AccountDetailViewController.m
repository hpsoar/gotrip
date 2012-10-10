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

@interface AccountDetailViewController () <DateInputTableViewCellDelegate>

@end

@implementation AccountDetailViewController
@synthesize account = _account;

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
        cell.titleLabel.text = @"日期";
        cell.valueTextField.text = [self.account.date toFullDate];
        return cell;
    }
    else {
        EditableCell *cell = [self editableCellForTableView:tableView];

        if (row == 0) {
            cell.titleLabel.text = @"标题";
            cell.valueTextField.text = self.account.title;
        }
        else {
            cell.titleLabel.text = @"花费";
            cell.valueTextField.text = [NSString stringWithFormat:@"￥%@", self.account.cost];
            cell.valueTextField.delegate = [TextFieldDelgates moneyTextFieldDelegate];
        }
        return cell;
    }
}

- (BillCell *)costCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"BillCell";
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (UITableViewCell *)chooserCellForTableView:(UITableView *)tableView withTitle:(NSString *)title {
    static NSString *CellIdentifier = @"ChooserCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = title;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForPayerAtRow:(NSInteger) row {
    EditableCell *cell = [self editableCellForTableView:tableView];
    cell.titleLabel.text = @"付款人";
    cell.valueTextField.text = self.account.payer.name;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForMemberAtRow:(NSInteger)row {
    BillCell *cell = [self costCellForTableView:tableView];
    SubAccount *consumption = [self.account.consumptions.allObjects objectAtIndex:row];
    cell.title = consumption.owner.name;
    cell.value = consumption.amount;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    cell.detailTextLabel.text = [value toFullDate];
}

@end
