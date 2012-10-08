//
//  EditableCell.h
//  GoTrip
//
//  Created by Aldrich Huang on 07/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@property BOOL valueIsEmpty;

@end
