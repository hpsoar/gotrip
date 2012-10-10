//
//  TripDetailTableViewController.m
//  GoTrip
//
//  Created by Aldrich Huang on 05/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "TripDetailViewController.h"
#import "AddMemberToTripViewController.h"
#import "TripAccountsViewController.h"
#import "UserTripActivitiesViewController.h"
#import "AddAccountViewController.h"
#import "AccountDetailViewController.h"
#import "BillCell.h"
#import "MemberCostCell.h"
#import "Utility.h"
#import "TripDatabase.h"

@interface TripDetailViewController () <AddAccountDelegate>
@property (nonatomic, strong) Member *selectedMember;
@property (nonatomic, strong) Account *currentAccount;
@end

@implementation TripDetailViewController

@synthesize trip = _trip;
@synthesize selectedMember = _selectedMember;
@synthesize currentAccount = _currentAccount;


static NSString *SegueAddTripMember = @"Add Trip Member";
static NSString *SegueShowTripAccounts = @"Show Trip Accounts";
static NSString *SegueShowTripAccountsForUser = @"Show Trip Accounts For User";
static NSString *SegueAddAccountToTrip = @"Add Trip Account";
static NSString *SegueEditTripAccount = @"Edit Trip Account";

- (IBAction)addAccount:(id)sender {
    [self performSegueWithIdentifier:SegueAddAccountToTrip sender:self];
}

- (void)addAccountViewController:(AddAccountViewController *)controller didAddAccount:(Account *)account {
    [self dismissModalViewControllerAnimated:YES];
    if (account) {
        self.currentAccount = account;
        [self performSegueWithIdentifier:SegueEditTripAccount sender:self];
    }
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
 
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = self.trip.name;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : self.trip.members.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row != self.trip.members.count) {
        return 60.0f;
    } else {
        return 44.0f;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        //return [NSString stringWithFormat:@"%@-%@", [self.trip.startDate toFullDate], self.trip.endDate ? [self.trip.endDate toFullDate] : @"now"]; // odd
        return nil;
    }
    else {
        return @"同伴";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"BillCell";
        BillCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.title = @"总花费";
        cell.value = [TripDatabase costForTrip:self.trip];
        return cell;
    }
    else if (indexPath.row < self.trip.members.count){
        static NSString *CellIdentifier = @"MemberCostCell";
        MemberCostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        Member *member = [self.trip.members.allObjects objectAtIndex:indexPath.row];
        cell.name = member.name;
        cell.pay = [TripDatabase payByMember:member inTrip:self.trip];
        cell.cost = [TripDatabase costForMember:member inTrip:self.trip];
        return cell;
    }
    else {
       static NSString *CellIdentifier = @"AddMemberCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"点击添加同伴";
        return cell;
    }
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) return UITableViewCellEditingStyleNone;
//    if (indexPath.row < self.trip.members.count) {
//        return UITableViewCellEditingStyleDelete;
//    }
//    else {
//        return UITableViewCellEditingStyleInsert;
//    }
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.trip removeMembersObject:[self.trip.members.allObjects objectAtIndex:indexPath.row]];
//        [[TripDatabase dba] save];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}


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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:SegueShowTripAccounts sender:self];
    }
    else if (indexPath.row < self.trip.members.count){
        self.selectedMember = [self.trip.members.allObjects objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:SegueShowTripAccountsForUser sender:self];
    }
    else {
        [self performSegueWithIdentifier:SegueAddTripMember sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SegueAddTripMember]) {
        AddMemberToTripViewController *controller = (AddMemberToTripViewController*)(((UINavigationController *)(segue.destinationViewController)).topViewController);
        controller.trip = self.trip;
    }
    else if ([segue.identifier isEqualToString:SegueShowTripAccounts]) {
        TripAccountsViewController *controller =(TripAccountsViewController *)segue.destinationViewController;
        controller.trip = self.trip;
    }
    else if ([segue.identifier isEqualToString:SegueShowTripAccountsForUser]){
        UserTripActivitiesViewController *controller = (UserTripActivitiesViewController*)segue.destinationViewController;
        controller.trip = self.trip;
        controller.member = self.selectedMember;
    }
    else if ([segue.identifier isEqualToString:SegueAddAccountToTrip]) {
        UINavigationController *navigation = (UINavigationController*)segue.destinationViewController;
        AddAccountViewController *controller = (AddAccountViewController*)navigation.topViewController;
        controller.trip = self.trip;
        controller.delegate = self;
    }
    else if ([segue.identifier isEqualToString:SegueEditTripAccount]) {
        AccountDetailViewController *controller = (AccountDetailViewController*)segue.destinationViewController;
        controller.account = self.currentAccount;
    }
}

@end
