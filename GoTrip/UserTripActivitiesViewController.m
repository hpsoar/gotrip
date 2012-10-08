//
//  UserTripActivitiesViewController.m
//  GoTrip
//
//  Created by Aldrich Huang on 07/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "UserTripActivitiesViewController.h"
#import "ActivityDetailViewController.h"
#import "TripDatabase.h"
#import "BillCell.h"
#import "MemberInfoViewController.h"

@interface UserTripActivitiesViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) Activity *selectedActivity;
@end

@implementation UserTripActivitiesViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize trip = _trip;
@synthesize member = _member;
@synthesize selectedActivity = _selectedActivity;

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [[TripDatabase dba] fetchRequestForEntity:@"Activity" sortBy:@"date"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"trip = %@ and %@ in members", self.trip, self.member];
        _fetchedResultsController = [[TripDatabase dba] fetchedResultsControllerForFetchRequest:fetchRequest sectionNameKeyPath:@"sectionKey" cacheName:@"Root"];
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
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
 
    self.navigationItem.title = self.member.name;
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

static NSString *kShowMemberInfo = @"Show Member Info";
- (IBAction)showMemberInfo:(id)sender {
    [self performSegueWithIdentifier:kShowMemberInfo sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    Activity *activity = [[sectionInfo objects] objectAtIndex:0];
    return [activity.date toFullDate];
}

- (void)configureCell:(BillCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Activity *activity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.title = activity.name;
    cell.value = activity.cost;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BillCell";
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate
static NSString *kShowActivityDetailSegue = @"Show Activity Detail";

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedActivity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:kShowActivityDetailSegue sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kShowActivityDetailSegue]) {
        ActivityDetailViewController *controller = (ActivityDetailViewController *)segue.destinationViewController;
        controller.activity = self.selectedActivity;
    }
    else if ([segue.identifier isEqualToString:kShowMemberInfo]){
        MemberInfoViewController *controller = (MemberInfoViewController*)segue.destinationViewController;
        controller.member = self.member;
    }
}

@end
