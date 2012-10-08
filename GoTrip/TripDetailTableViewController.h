//
//  TripDetailTableViewController.h
//  GoTrip
//
//  Created by Aldrich Huang on 05/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@interface TripDetailTableViewController : UITableViewController
@property (nonatomic, strong) Trip *trip;
@end
