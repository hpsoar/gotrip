//
//  TripListTableViewController.m
//  GoTrip
//
//  Created by Aldrich Huang on 04/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "TripDetailViewController.h"
#import "TripListViewController.h"
#import "AddTripViewController.h"
#import "TripDatabase.h"
#import "Utility.h"
#import "TripItemCell.h"

@interface TripListViewController () <AddTripDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) Trip *selectedTrip;
@property (weak, nonatomic) IBOutlet UIImageView *emptyTripListImageView;
@end

@implementation TripListViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize selectedTrip = _selectedTrip;
@synthesize emptyTripListImageView = _emptyTripListImageView;

// TODO: all dba related code should be extracted to TripDatabase, or its extensions
- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        _fetchedResultsController = [[TripDatabase dba]fetchedResultsControllerForEntityName:@"Trip" sortBy:@"name" sectionNameKeyPath:nil cacheName:@"Root"];
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

#pragma mark - UIViewController life-cycle
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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTrip:)];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    if (self.fetchedResultsController.fetchedObjects.count > 0)
        self.emptyTripListImageView.hidden = YES;
    else
        self.emptyTripListImageView.hidden = NO;
}

- (void)viewDidUnload
{
    [self setEmptyTripListImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.fetchedResultsController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

static NSString *kShowTripDetailSegue = @"Show Trip Detail";

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kShowTripDetailSegue]) {
        TripDetailViewController *controller = (TripDetailViewController*)segue.destinationViewController;
        controller.trip = self.selectedTrip;
    }
}

#pragma mark - UI action
- (void)addTrip : (id)sender {
    AddTripViewController *addTripController = [[AddTripViewController alloc] initWithNibName:@"AddTripView" bundle:nil];
    addTripController.delegate = self;
    
    [self presentModalViewController:[[UINavigationController alloc] initWithRootViewController:addTripController] animated:YES];
}

#pragma mark - AddTripDelegate
- (void)addTripViewController:(AddTripViewController *)controller didAddTrip:(Trip *)trip {
    [self dismissModalViewControllerAnimated:YES];
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

- (void)configureCell:(TripItemCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell loadCellData:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TripItemCell";
    TripItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[TripDatabase dba] deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        [[TripDatabase dba] save];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:kShowTripDetailSegue sender:self];
}

#pragma mark - UIFetchedResultsControllerDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:YES];
            self.emptyTripListImageView.hidden = YES;
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
            if (self.fetchedResultsController.fetchedObjects.count == 0)
                self.emptyTripListImageView.hidden = NO;
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(TripItemCell*)[self.tableView cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
            break;
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
