//
//  ChoosePayerViewController.h
//  GoTrip
//
//  Created by Aldrich Huang on 07/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;

@interface ChoosePayerViewController : UITableViewController
@property (nonatomic, strong) Account *account;
@end
