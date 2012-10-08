//
//  MemberInfoViewController.m
//  GoTrip
//
//  Created by Aldrich Huang on 07/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "MemberInfoViewController.h"
#import "TripDatabase.h"
#import "EditableCell.h"
#import "TextFieldDelegate.h"
#import "PhoneNumberFormatter.h"

@interface MemberInfoViewController ()
@end

@implementation MemberInfoViewController
@synthesize member = _member;

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

static int semaphore = 0;

- (void)autoFormatTextField:(UITextField *)sender {
    if (semaphore) return;
    semaphore = 1;
    sender.text = [[Utility phoneNumberFormatter] format:sender.text withLocale:@"jp"];
    semaphore = 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EditableCell";
    EditableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    
    cell.valueTextField.enabled = self.editing;
    
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"姓名";
            cell.valueTextField.text = self.member.name;
            break;
        case 1:
            cell.titleLabel.text = @"电话";
            cell.valueTextField.text = self.member.mobile;
            cell.valueTextField.delegate = [TextFieldDelgates phoneTextFieldDelegate];
//            [cell.valueTextField addTarget:self action:@selector(autoFormatTextField:) forControlEvents:UIControlEventEditingChanged];
            break;
        case 2:
            cell.titleLabel.text = @"E-mail";
            cell.valueTextField.text = self.member.email;
            cell.valueTextField.delegate = [TextFieldDelgates emailTextFieldDelgate];
            break;
        case 3:
            cell.titleLabel.text = @"QQ";
            cell.valueTextField.text = self.member.qq;
            break;
        default:
            break;
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

- (EditableCell *)cellForRow:(NSInteger)row {
    return (EditableCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (!editing) {
        EditableCell *cell = [self cellForRow:0];
        if (!cell.valueIsEmpty) self.member.name = cell.valueTextField.text;
        cell = [self cellForRow:1];
        self.member.mobile = cell.valueTextField.text;
        cell = [self cellForRow:2];
        self.member.email = cell.valueTextField.text;
        cell = [self cellForRow:3];
        self.member.qq = cell.valueTextField.text;
        [[TripDatabase dba] save];
    }
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
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
