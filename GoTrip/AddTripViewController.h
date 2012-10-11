//
//  AddTripViewController.h
//  GoTrip
//
//  Created by Aldrich Huang on 04/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddTripViewController;
@class Trip;
@class TripDatabase;

@protocol AddTripDelegate <NSObject>

- (void)addTripViewController:(AddTripViewController *)controller didAddTrip:(Trip *)trip;

@end

@interface AddTripViewController : UIViewController

@property (nonatomic, strong) id <AddTripDelegate> delegate;

@end
