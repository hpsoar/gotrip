//
//  ActivityCostCell.m
//  GoTrip
//
//  Created by Aldrich Huang on 05/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "BillCell.h"
#import "Utility.h"

@interface BillCell ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@end

@implementation BillCell
@synthesize titleLabel, valueLabel;

@synthesize title = _title;

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setValue:(NSNumber *)value {
    NSString *text = [Utility numberToCurrencyText:[NSNumber numberWithInteger:ABS(value.integerValue)]];
    NSString *prefix = @"";
    if (value.integerValue < 0) {
        prefix = @"-";
        self.valueLabel.textColor = [UIColor redColor];
    }
    self.valueLabel.text = [NSString stringWithFormat:@"%@%@", prefix, text];
}

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

@end
