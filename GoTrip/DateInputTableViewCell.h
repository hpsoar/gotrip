//
//  DateInputTableViewCell.h
//  ShootStudio
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateInputTableViewCell;

@protocol DateInputTableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value;
@end

@interface DateInputTableViewCell : UITableViewCell <UIPopoverControllerDelegate> {
	UIPopoverController *popoverController;
	UIToolbar *inputAccessoryView;
}

@property (nonatomic, strong) NSDate *dateValue;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (weak) IBOutlet id<DateInputTableViewCellDelegate> delegate;

- (void)setMaxDate:(NSDate *)max;
- (void)setMinDate:(NSDate *)min;
- (void)setMinuteInterval:(NSUInteger)value;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@end
