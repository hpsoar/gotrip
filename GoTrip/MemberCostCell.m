//
//  MemberCostCell.m
//  GoTrip
//
//  Created by Aldrich Huang on 05/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "MemberCostCell.h"

@interface MemberCostCell()
@property (nonatomic, weak) IBOutlet UILabel *memberNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *payLabel;
@property (nonatomic, weak) IBOutlet UILabel *costLabel;
@end

@implementation MemberCostCell
@synthesize memberNameLabel, payLabel, costLabel;

- (void)setName:(NSString *)name {
    self.memberNameLabel.text = name;
}

- (void)setCost:(NSNumber *)cost {
    self.costLabel.text = [NSString stringWithFormat:@"-￥%@", cost];
}

- (void)setPay:(NSNumber *)pay {
    self.payLabel.text = [NSString stringWithFormat:@"+￥%@", pay];
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
