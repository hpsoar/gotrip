//
//  TripActivitiesViewController.h
//  GoTrip
//
//  Created by Aldrich Huang on 05/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Trip;

@interface TripActivitiesViewController : UITableViewController
@property (nonatomic, weak) Trip *trip;
@end
