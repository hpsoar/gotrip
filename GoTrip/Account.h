//
//  Account.h
//  GoTrip
//
//  Created by Aldrich Huang on 10/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Member, SubAccount, Trip;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *consumptions;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) Member *payer;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addConsumptionsObject:(SubAccount *)value;
- (void)removeConsumptionsObject:(SubAccount *)value;
- (void)addConsumptions:(NSSet *)values;
- (void)removeConsumptions:(NSSet *)values;

@end
