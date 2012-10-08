//
//  TripDatabase.m
//  GoTrip
//
//  Created by Aldrich Huang on 06/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "TripDatabase.h"

@implementation TripDatabase

static DBA *g_tripDatabase;

+ (DBA *)dba {
    if (!g_tripDatabase) {
        g_tripDatabase = [[DBA alloc] initWithDatabaseName:@"Trips"];
    }
    return g_tripDatabase;
}

+ (NSNumber *)costRemainForActivity:(Activity *)activity {
    __block float paid = 0;
    [activity.pays enumerateObjectsUsingBlock:^(Pay *pay, BOOL *stop) {
        paid += pay.amount.floatValue;
    }];
    return [NSNumber numberWithFloat:(activity.cost.floatValue - paid)];
}

+ (NSNumber *)computeCostForTrip:(Trip *)trip {
    __block float cost = 0;
    [trip.activities enumerateObjectsUsingBlock:^(Activity* activity, BOOL *stop) {
        cost += activity.cost.floatValue;
    }];
    return [NSNumber numberWithFloat:cost];
}

+ (NSNumber *)computeCostForMember:(Member *)member forTrip:(Trip *)trip {
    __block float cost = 0;
    [trip.activities enumerateObjectsUsingBlock:^(Activity *activity, BOOL *stop){
        if ([activity.members containsObject:member]) {
            cost += activity.cost.floatValue / activity.members.count;
        }
    }];
    return [NSNumber numberWithFloat:cost];
}

+ (NSNumber *)computePayForMember:(Member *)member forTrip:(Trip *)trip {
    __block float totalPay = 0;
    [trip.activities enumerateObjectsUsingBlock:^(Activity *activity, BOOL *stop) {
        [activity.pays enumerateObjectsUsingBlock:^(Pay *pay, BOOL *stop){
            if (pay.payer == member) totalPay += pay.amount.floatValue;
        }];
    }];
    return [NSNumber numberWithFloat:totalPay];
}

+ (Pay*)payForActivity:(Activity *)activity byMember:(Member *)member {
    __block Pay *result = nil;
    [activity.pays enumerateObjectsUsingBlock:^(Pay *pay, BOOL *stop) {
        if (pay.payer == member) {
            result = pay;
            *stop = YES;
        }
    }];
    return result;
}

+ (void)addPay:(NSNumber *)amount byMember:(Member *)member forActivity:(Activity *)activity {
    Pay *pay = [g_tripDatabase insertNewObjectForEntityForName:@"Pay"];
    pay.activity = activity;
    pay.payer = member;
    pay.amount = amount;
    [member addPaysObject:pay];
    [activity addPaysObject:pay];
}

+ (void)removePay:(Pay *)pay {
    [pay.payer removePaysObject:pay];
    [pay.activity removePaysObject:pay];
    [g_tripDatabase deleteObject:pay];
}

@end
