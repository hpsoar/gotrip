//
//  EditableCell.m
//  GoTrip
//
//  Created by Aldrich Huang on 07/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "EditableCell.h"

@implementation EditableCell
@synthesize titleLabel;
@synthesize valueTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)valueIsEmpty {
    return [self.valueTextField.text isEqualToString:@""];
}

- (void)setValueIsEmpty:(BOOL)valueIsEmpty { }

- (float)floatValue {
    return self.valueTextField.text.floatValue;
}

- (void)setFloatValue:(float)floatValue {
    
}

- (NSNumber*)numberValue {
    return [NSNumber numberWithFloat:self.floatValue];
}

@end
