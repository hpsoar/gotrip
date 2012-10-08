//
//  TripDatabase.h
//  GoTrip
//
//  Created by Aldrich Huang on 06/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBA.h"
#import "Trip.h"
#import "Member.h"
#import "Activity.h"
#import "Pay.h"

@interface TripDatabase : NSObject

+ (DBA *)dba;

+ (NSNumber *)costRemainForActivity:(Activity *)activity;

+ (NSNumber *)computeCostForTrip:(Trip *)trip;

+ (NSNumber *)computeCostForMember:(Member *)member forTrip:(Trip *)trip;

+ (NSNumber *)computePayForMember:(Member *)member forTrip:(Trip *)trip;

+ (Pay*)payForActivity:(Activity *)activity byMember:(Member *)member;

+ (void)addPay:(NSNumber *)amout byMember:(Member *)member forActivity:(Activity *)activity;

+ (void)removePay:(Pay *)pay;
@end
