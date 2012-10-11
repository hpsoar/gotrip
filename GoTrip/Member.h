//
//  Member.h
//  GoTrip
//
//  Created by Aldrich Huang on 10/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, SubAccount, Trip;

@interface Member : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * qq;
@property (nonatomic, retain) NSSet *consumptions;
@property (nonatomic, retain) NSSet *trips;
@property (nonatomic, retain) NSSet *payments;
@end

@interface Member (CoreDataGeneratedAccessors)

- (void)addConsumptionsObject:(SubAccount *)value;
- (void)removeConsumptionsObject:(SubAccount *)value;
- (void)addConsumptions:(NSSet *)values;
- (void)removeConsumptions:(NSSet *)values;

- (void)addTripsObject:(Trip *)value;
- (void)removeTripsObject:(Trip *)value;
- (void)addTrips:(NSSet *)values;
- (void)removeTrips:(NSSet *)values;

- (void)addPaymentsObject:(Account *)value;
- (void)removePaymentsObject:(Account *)value;
- (void)addPayments:(NSSet *)values;
- (void)removePayments:(NSSet *)values;

@end
