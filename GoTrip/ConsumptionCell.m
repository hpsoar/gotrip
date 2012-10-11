//
//  ConsumptionCell.m
//  GoTrip
//
//  Created by Aldrich Huang on 11/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "ConsumptionCell.h"

@implementation ConsumptionCell
@synthesize consumptionStateButton;
@synthesize valueTextField;
@synthesize titleLabel;

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
- (IBAction)toggleAA:(UIButton *)sender {
    sender.tag = self.valueTextField.tag;
    [self.delegate consumptionStateButtonChanged:sender];
}

@end
