//
//  Pay.h
//  GoTrip
//
//  Created by Aldrich Huang on 06/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, Member;

@interface Pay : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) Activity *activity;
@property (nonatomic, retain) Member *payer;

@end
