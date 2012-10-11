//
//  ConsumptionCell.h
//  GoTrip
//
//  Created by Aldrich Huang on 11/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConsumptionStateDelegate <NSObject>

- (void)consumptionStateChanged:(NSInteger)index;

@end

@interface ConsumptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) id <ConsumptionStateDelegate> delegate;

@end
