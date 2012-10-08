//
//  AddMemberToTripViewController.m
//  GoTrip
//
//  Created by Aldrich Huang on 05/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "AddMemberToTripViewController.h"
#import "TripDatabase.h"
#import "Utility.h"

@interface AddMemberToTripViewController () <NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) NSFetchedResultsController *fetchtedMembersController;
@end

@implementation AddMemberToTripViewController
@synthesize nameTextField = _nameTextField;
@synthesize trip = _trip;
@synthesize fetchtedMembersController = _fetchtedMembersController;

- (NSFetchedResultsController *)fetchtedMembersController {
    if (!_fetchtedMembersController) {
        _fetchtedMembersController = [[TripDatabase dba] fetchedResultsControllerForEntityName:@"Member" sortBy:@"name" sectionNameKeyPath:nil  cacheName:@"Root"];
        _fetchtedMembersController.delegate = self;
    }
    return _fetchtedMembersController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)addMember:(id)sender {
    if (![self.nameTextField.text isEqualToString:@""]) {
        Member *member = [[TripDatabase dba] insertNewObjectForEntityForName:@"Member"];
        
        member.name = self.nameTextField.text;
        
        [self.trip addMembersObject:member];
        
        [[TripDatabase dba] save];

        self.nameTextField.text = @"";
    }
    [self.nameTextField resignFirstResponder];
}

- (IBAction)doneWithChoosing:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO; 
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
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
    return self.fetchtedMembersController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchtedMembersController.sections objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"从下面选择";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DefaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Member *member = [self.fetchtedMembersController objectAtIndexPath:indexPath];
    cell.textLabel.text =member.name;
    if ([self.trip.members containsObject:member]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Member *member = [self.fetchtedMembersController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.trip.members containsObject:member]) {
        // TODO: the member may have pays, check it and ask user for deletion confirmation
        [self.trip removeMembersObject:member];
        [[TripDatabase dba] save];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        [self.trip addMembersObject:member];
        [[TripDatabase dba] save];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:YES];
            break;
            
        default:
            break;
    }
}

@end
