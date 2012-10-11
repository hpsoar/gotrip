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
#import "Account.h"
#import "SubAccount.h"

@interface TripDatabase : NSObject

+ (DBA *)dba;

//+ (NSFetchedResultsController *)fetchedTripsController;

+ (NSNumber *)costForTrip:(Trip *)trip;

+ (Trip *)addTripWithName:(NSString *)name;

//+ (NSNumber *)costRemainForActivity:(Activity *)activity;

+ (NSArray *)allMembers;

+ (Member *)addMemberWithName:(NSString *)name;

+ (Member *)MemberInTrip:(Trip*)trip withName:(NSString *)memberName;

+ (Member *)addMemberWithName:(NSString *)memberName toTrip:(Trip *)trip;

+ (void)addMember:(Member*)member toTrip:(Trip*)trip;

+ (NSNumber *)costForMember:(Member *)member inTrip:(Trip *)trip;

+ (NSNumber *)payByMember:(Member *)member inTrip:(Trip *)trip;

+ (Account *)addAccountWithTitle:(NSString *)title withCost:(NSNumber *) cost toTrip:(Trip *)trip;

+ (void)updateConsumptionForAccount:(Account *)account;

+ (NSMutableArray *)balanceForMember:(Member*)member inTrip:(Trip*)trip;
+ (NSNumber *)balanceForMember:(Member *)member inAccount:(Account *)account;

//+ (Pay*)payForActivity:(Activity *)activity byMember:(Member *)member;
//
//+ (void)addPay:(NSNumber *)amout byMember:(Member *)member forActivity:(Activity *)activity;
//
//+ (void)removePay:(Pay *)pay;
@end
