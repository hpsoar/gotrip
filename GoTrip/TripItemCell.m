//
//  TripItemCell.m
//  GoTrip
//
//  Created by Aldrich Huang on 04/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "TripItemCell.h"
#import "TripDatabase.h"
#import "Utility.h"

@implementation TripItemCell
@synthesize titleLabel;
@synthesize costLabel;
@synthesize startDateLabel;
@synthesize endDateLabel;
@synthesize numberOfMemberLabel;

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

- (void)loadCellData:(Trip *)trip {
    self.titleLabel.text = trip.name;
    self.costLabel.text = [NSString stringWithFormat:@"￥%@", [TripDatabase computeCostForTrip:trip]];
    self.startDateLabel.text = [trip.startDate toFullDate];
    self.endDateLabel.text = trip.endDate ? [trip.endDate toShortDate] : @"现在";
    self.numberOfMemberLabel.text = [NSString stringWithFormat:@"%d", trip.members.count];
}

@end
