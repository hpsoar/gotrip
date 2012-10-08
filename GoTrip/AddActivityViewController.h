//
//  AddActivityViewController.h
//  GoTrip
//
//  Created by Aldrich Huang on 06/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trip;
@class Activity;

@class AddActivityViewController;

@protocol AddActivityDelegate <NSObject>

- (void)addActivityViewController:(AddActivityViewController *)controller didAddActivity:(Activity *)activity;

@end

@interface AddActivityViewController : UITableViewController
@property (nonatomic, weak) Trip *trip;
@end
