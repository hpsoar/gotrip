//
//  AddMemberToTripViewController.h
//  GoTrip
//
//  Created by Aldrich Huang on 05/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@class AddMemberToTripViewController;

@protocol AddMemberToTripDelegate <NSObject>

- (void)addMemberToTripViewController:(AddMemberToTripViewController *)controller didAddMember:(Member*)member;

@end

@interface AddMemberToTripViewController : UITableViewController
@property (nonatomic, strong) Trip *trip;
@end
