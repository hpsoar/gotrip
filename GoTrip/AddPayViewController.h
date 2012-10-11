//
//  ViewController.h
//  GoTrip
//
//  Created by Aldrich Huang on 04/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;
@class Member;

@interface AddPayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) Activity *activity;
@property (nonatomic, strong) Member *member;
@end
