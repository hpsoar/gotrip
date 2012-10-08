//
//  TripActivitiesViewController.m
//  GoTrip
//
//  Created by Aldrich Huang on 05/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "TripActivitiesViewController.h"
#import "AddActivityViewController.h"
#import "ActivityDetailViewController.h"
#import "BillCell.h"
#import "TripDatabase.h"

@interface TripActivitiesViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic, strong) NSMutableArray *activeDays;
//@property (nonatomic, strong) NSMutableArray *groupedActivities;

@property (nonatomic, strong) Activity *selectedActivity;
@end

@implementation TripActivitiesViewController
@synthesize fetchedResultsController = _fetchedResultsController;
//@synthesize activeDays = _activeDays;
//@synthesize groupedActivities = _groupedActivities;
@synthesize selectedActivity = _selectedActivity;

static NSString *kAddActivitySegue = @"Add Activity";
static NSString *kShowActivityDetailSegue = @"Show Activity Detail";

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [[TripDatabase dba] fetchRequestForEntity:@"Activity" sortBy:@"date"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"trip = %@", self.trip];
        _fetchedResultsController = [[TripDatabase dba] fetchedResultsControllerForFetchRequest:fetchRequest sectionNameKeyPath:@"sectionKey" cacheName:@"Root"];
        _fetchedResultsController.delegate = self;
    }
   
    return _fetchedResultsController;
}

- (IBAction)addActivity:(id)sender {
    [self performSegueWithIdentifier:kAddActivitySegue sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kAddActivitySegue]) {
        UINavigationController *navigation = (UINavigationController *)(segue.destinationViewController);
        AddActivityViewController *controller = (AddActivityViewController *)(navigation.topViewController);
        controller.trip = self.trip;
    }
    else if ([segue.identifier isEqualToString:kShowActivityDetailSegue]) {
        ActivityDetailViewController *controller = (ActivityDetailViewController *)segue.destinationViewController;
        controller.activity = self.selectedActivity;
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    NSSet *activeDays = [self.trip.activities valueForKeyPath:@"sectionKey"];
//    self.activeDays = [[NSMutableArray alloc] initWithArray:activeDays.allObjects];
//    [self.activeDays sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return obj1 > obj2;
//    }];
//    
//    self.groupedActivities = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < self.activeDays.count; ++i) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.sectionKey = %@", [self.activeDays objectAtIndex:i]];
//        NSMutableArray *activityGroup = [[NSMutableArray alloc] initWithArray:[self.trip.activities filteredSetUsingPredicate:predicate].allObjects];
//        [self.groupedActivities addObject:activityGroup];
//    }
//    NSLog(@"%@", self.activeDays);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedActivity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:kShowActivityDetailSegue sender:self];
}


#pragma mark - UIFetchedResultsControllerDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:YES];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(BillCell *)[self.tableView cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
        default:
            break;
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
