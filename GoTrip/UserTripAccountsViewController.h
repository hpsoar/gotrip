//
//  UserTripActivitiesViewController.h
//  GoTrip
//
//  Created by Aldrich Huang on 07/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trip;
@class Member;

@interface UserTripAccountsViewController : UITableViewController
@property (nonatomic, strong) Member *member;
@property (nonatomic, strong) Trip *trip;
@end
