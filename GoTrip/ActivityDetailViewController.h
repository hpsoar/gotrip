//
//  ActivityDetailViewController.h
//  GoTrip
//
//  Created by Aldrich Huang on 07/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

@interface ActivityDetailViewController : UITableViewController
@property (nonatomic, strong) Activity *activity;
@end
