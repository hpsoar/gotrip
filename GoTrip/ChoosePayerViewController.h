//
//  ChoosePayerViewController.h
//  GoTrip
//
//  Created by Aldrich Huang on 07/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Account;
//@class Member;
//
//@class ChoosePayerViewController;
//
//@protocol ChoosePayerViewControllerDelegate <NSObject>
//        
//- (void)choosePayerViewController:(ChoosePayerViewController *)controller didChoosePayer:(Member *)member;
//
//@end

@interface ChoosePayerViewController : UITableViewController
@property (nonatomic, strong) Account *account;
//@property (nonatomic, strong) id <ChoosePayerViewControllerDelegate> delegate;
@end
