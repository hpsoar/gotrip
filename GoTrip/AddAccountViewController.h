//
//  AddActivityViewController.h
//  GoTrip
//
//  Created by Aldrich Huang on 06/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trip;
@class Account;

@class AddAccountViewController;

@protocol AddAccountDelegate <NSObject>

- (void)addAccountViewController:(AddAccountViewController *)controller didAddAccount:(Account *)account;

@end

@interface AddAccountViewController : UITableViewController
@property (nonatomic, strong) Trip *trip;
@property (nonatomic, strong) id <AddAccountDelegate> delegate;
@end
