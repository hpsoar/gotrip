//
//  ActivityDetailViewController.h
//  GoTrip
//
//  Created by Aldrich Huang on 07/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account+WithSectionKey.h"

@interface AccountDetailViewController : UITableViewController
@property (nonatomic, strong) Account *account;
@end
