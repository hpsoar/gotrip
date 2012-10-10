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

+ (NSNumber *)costForTrip:(Trip *)trip {
    __block float cost = 0;
    [trip.accounts enumerateObjectsUsingBlock:^(Account* account, BOOL *stop) {
        cost += account.cost.floatValue;
    }];
    return [NSNumber numberWithFloat:cost];
}

+ (Trip *)addTripWithName:(NSString *)name {
    Trip *trip = [[TripDatabase dba] insertNewObjectForEntityForName:@"Trip"];
    trip.name = name;
    trip.startDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    [[TripDatabase dba] save];
    return trip;
}

//+ (NSNumber *)costRemainForActivity:(Activity *)activity {
//    __block float paid = 0;
//    [activity.pays enumerateObjectsUsingBlock:^(Pay *pay, BOOL *stop) {
//        paid += pay.amount.floatValue;
//    }];
//    return [NSNumber numberWithFloat:(activity.cost.floatValue - paid)];
//}

+ (NSArray *)allMembers {
    NSFetchRequest *fetchRequest = [[TripDatabase dba] fetchRequestForEntity:@"Member" sortBy:@"name"];
    return  [[TripDatabase dba] executeFetchRequest:fetchRequest];
}

+ (Member *)MemberInTrip:(Trip*)trip withName:(NSString *)memberName {
    __block Member *result = nil;
    [trip.members enumerateObjectsUsingBlock:^(Member *member, BOOL *stop) {
        if (member.name == memberName) {
            result = member;
            *stop = YES;
        }
    }];
    return result;
}

+ (Member *)addMemberWithName:(NSString *)name {
    Member *member = [[TripDatabase dba] insertNewObjectForEntityForName:@"Member"];
    member.name = name;
    
    [[TripDatabase dba] save];
    
    return member;
}

+ (Member *)memberWithName:(NSString *)name {
    NSFetchRequest *fetchRequest = [[TripDatabase dba] fetchRequestForEntity:@"Member" sortBy:nil];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = '%@'", name];
    return [[[TripDatabase dba] executeFetchRequest:fetchRequest] lastObject];
}

+ (void)addMember:(Member*)member toTrip:(Trip*)trip {
    if ([trip.members containsObject:member]) return;
    
    [TripDatabase __addMember:member toTrip:trip];
}

+ (void)__addMember:(Member*)member toTrip:(Trip*)trip {
    if (!member) return; // TODO: did addMembersObject check this? do a test
    
    [member addTripsObject:trip];
    [trip addMembersObject:member];
    
    [[TripDatabase dba] save];
}

+ (Member *)addMemberWithName:(NSString *)memberName toTrip:(Trip *)trip {
    Member *member = [TripDatabase MemberInTrip:trip withName:memberName];
    if (member) return member;
    
    member = [TripDatabase memberWithName:memberName];
    if (!member) {
        member = [TripDatabase addMemberWithName:memberName];
    }
    
    [TripDatabase __addMember:member toTrip:trip];
 
    return member;
}

+ (NSNumber *)costForMember:(Member *)member inTrip:(Trip *)trip {
    __block float cost = 0;
    [trip.accounts enumerateObjectsUsingBlock:^(Account *account, BOOL *stop){
        [account.consumptions enumerateObjectsUsingBlock:^(SubAccount *subAccount, BOOL *stop) {
            if (subAccount.owner == member)
                cost += subAccount.amount.floatValue;
        }];
    }];
    return [NSNumber numberWithFloat:cost];
}

+ (NSNumber *)payByMember:(Member *)member inTrip:(Trip *)trip {
    __block float totalPay = 0;
    [trip.accounts enumerateObjectsUsingBlock:^(Account *account, BOOL *stop) {
        [account.expenditures enumerateObjectsUsingBlock:^(SubAccount *subAccount, BOOL *stop){
            if (subAccount.owner == member) totalPay += subAccount.amount.floatValue;
        }];
    }];
    return [NSNumber numberWithFloat:totalPay];
}

//+ (SubAccount*)payForAccount:(Account *)account byMember:(Member *)member {
//    __block Pay *result = nil;
//    [activity.pays enumerateObjectsUsingBlock:^(Pay *pay, BOOL *stop) {
//        if (pay.payer == member) {
//            result = pay;
//            *stop = YES;
//        }
//    }];
//    return result;
//}

//+ (void)addPay:(NSNumber *)amount byMember:(Member *)member forActivity:(Activity *)activity {
//    Pay *pay = [g_tripDatabase insertNewObjectForEntityForName:@"Pay"];
//    pay.activity = activity;
//    pay.payer = member;
//    pay.amount = amount;
//    [member addPaysObject:pay];
//    [activity addPaysObject:pay];
//}

//+ (void)removePay:(Pay *)pay {
//    [pay.payer removePaysObject:pay];
//    [pay.activity removePaysObject:pay];
//    [g_tripDatabase deleteObject:pay];
//}

+ (SubAccount *)addSubAccountToAccount:(Account *)account forMember:(Member*)member {
    SubAccount *subaccount = [[TripDatabase dba] insertNewObjectForEntityForName:@"SubAccount"];
    subaccount.account = account;
    subaccount.owner = member;
    subaccount.amount = [NSNumber numberWithFloat:0];
    [account addConsumptionsObject:subaccount];
    [member addConsumptionsObject:subaccount];
    return subaccount;
}

+ (Account *)addAccountWithTitle:(NSString *)title withCost:(float) cost toTrip:(Trip *)trip {
    Account *account = [[TripDatabase dba] insertNewObjectForEntityForName:@"Account"];
    account.title = title;
    account.cost = [NSNumber numberWithFloat:cost];
    account.date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    [trip.members enumerateObjectsUsingBlock:^(Member *member, BOOL *stop) {
        [TripDatabase addSubAccountToAccount:account forMember:member];
    }];
    
    account.trip = trip;
    [trip addAccountsObject:account];
    
    [[TripDatabase dba] save];
    
    return account;
}

@end
