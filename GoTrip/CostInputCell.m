//
//  CostInputCell.m
//  GoTrip
//
//  Created by Aldrich Huang on 06/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "CostInputCell.h"

@implementation CostInputCell
@synthesize titleLabel, valueTextField;

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
