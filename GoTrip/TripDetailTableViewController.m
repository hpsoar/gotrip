//
//  TripDetailTableViewController.m
//  GoTrip
//
//  Created by Aldrich Huang on 05/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "TripDetailTableViewController.h"
#import "AddMemberToTripViewController.h"
#import "TripActivitiesViewController.h"
#import "UserTripActivitiesViewController.h"
#import "BillCell.h"
#import "MemberCostCell.h"
#import "Utility.h"
#import "TripDatabase.h"

@interface TripDetailTableViewController ()
@property (nonatomic, strong) Member *selectedMember;
@end

@implementation TripDetailTableViewController

@synthesize trip = _trip;
@synthesize selectedMember = _selectedMember;

// TODO: also need the members' pays for the trip

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
        cell.value = [TripDatabase computeCostForTrip:self.trip];
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
        cell.pay = [TripDatabase computePayForMember:member forTrip:self.trip];
        cell.cost = [TripDatabase computeCostForMember:member forTrip:self.trip];
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return UITableViewCellEditingStyleNone;
    if (indexPath.row < self.trip.members.count) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleInsert;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.trip removeMembersObject:[self.trip.members.allObjects objectAtIndex:indexPath.row]];
        [[TripDatabase dba] save];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

static NSString *kAddTripMemberSegue = @"Add Trip Member";
static NSString *kShowTripActivities = @"Show Trip Activities";
static NSString *kShowTripActivitiesForUser = @"Show Trip Activities For User";
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:kShowTripActivities sender:self];
    }
    else if (indexPath.row < self.trip.members.count){
        self.selectedMember = [self.trip.members.allObjects objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:kShowTripActivitiesForUser sender:self];
    }
    else {
        [self performSegueWithIdentifier:kAddTripMemberSegue sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kAddTripMemberSegue]) {
        AddMemberToTripViewController *controller = (AddMemberToTripViewController*)(((UINavigationController *)(segue.destinationViewController)).topViewController);
        controller.trip = self.trip;
    }
    else if ([segue.identifier isEqualToString:kShowTripActivities]) {
        TripActivitiesViewController *controller =(TripActivitiesViewController *)segue.destinationViewController;
        controller.trip = self.trip;
    }
    else {
        UserTripActivitiesViewController *controller = (UserTripActivitiesViewController*)segue.destinationViewController;
        controller.trip = self.trip;
        controller.member = self.selectedMember;
    }
}

@end
