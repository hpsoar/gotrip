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
        if (account.payer == member)
            totalPay += account.cost.floatValue;
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
    subaccount.isAA = [NSNumber numberWithBool:YES];
    [account addConsumptionsObject:subaccount];
    [member addConsumptionsObject:subaccount];
    return subaccount;
}

//+ (NSArray *)AAconsumptionOfAmount:(float)cost Among:(NSInteger)numberOfPerson {
//    if (numberOfPerson == 0) return nil;
//    ns
//}

+ (NSInteger)numberOfAAConsumptionForAccount:(Account *)account {
    __block NSInteger num = 0;
    [account.consumptions enumerateObjectsUsingBlock:^(SubAccount *consumption, BOOL *stop) {
        if (consumption.isAA.boolValue) ++num;
    }];
    return num;
}

+ (NSInteger)amountOfCostToAAForAccount:(Account *)account {
    __block NSInteger amount = account.cost.integerValue;
    [account.consumptions enumerateObjectsUsingBlock:^(SubAccount *consumption, BOOL *stop) {
        if (!consumption.isAA.boolValue) amount -= consumption.amount.integerValue;
    }];
    return amount;
}

+ (void)AA:(NSInteger)amount Among:(NSInteger)number forAccount:(Account *)account {
    if (number == 0 || amount < 0) return;
    
    NSInteger amountPerSubAccount = amount / number;
    NSInteger remainder = amount % number;

    NSInteger theFirstToAdd1 = rand() % number;
    NSInteger end = remainder + theFirstToAdd1;
    NSInteger roundedEnd = end - number;
    
    __block NSInteger idx = 0;
    [account.consumptions enumerateObjectsUsingBlock:^(SubAccount *consumption, BOOL *stop) {
        if (consumption.isAA.boolValue) {
            NSInteger amount = amountPerSubAccount;
            
            if (idx < roundedEnd || (idx >= theFirstToAdd1 && idx < end)) ++amount;
            
            consumption.amount = [NSNumber numberWithInteger:amount];
            ++idx;
        }
    }]; 
}

+ (void)updateConsumptionForAccount:(Account *)account {
    // TODO: can be optimized if needs to improve efficiency
    NSInteger numOfAA = [TripDatabase numberOfAAConsumptionForAccount:account];
    NSInteger amountToAA = [TripDatabase amountOfCostToAAForAccount:account];
    [TripDatabase AA:amountToAA Among:numOfAA forAccount:account];
}

+ (Account *)addAccountWithTitle:(NSString *)title withCost:(NSNumber*) cost toTrip:(Trip *)trip {
    Account *account = [[TripDatabase dba] insertNewObjectForEntityForName:@"Account"];
    account.title = title;
    account.cost = cost;
    account.date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    [trip.members enumerateObjectsUsingBlock:^(Member *member, BOOL *stop) {
        [TripDatabase addSubAccountToAccount:account forMember:member];
    }];
    
    [TripDatabase AA:cost.integerValue Among:account.consumptions.count forAccount:account];
    
    account.trip = trip;
    [trip addAccountsObject:account];
    
    [[TripDatabase dba] save];
    
    return account;
}

+ (NSNumber *)balanceForMember:(Member *)member inAccount:(Account *)account {
    __block NSInteger balance = 0;
    if (account.payer == member) balance += account.cost.integerValue;
    [account.consumptions enumerateObjectsUsingBlock:^(SubAccount *subAccount, BOOL *stop) {
        if (subAccount.owner == member) {
            balance -= subAccount.amount.integerValue;
            *stop = YES;
        }
    }];
    return [NSNumber numberWithInteger:balance];
}

+ (NSMutableArray *)balanceForMember:(Member*)member inTrip:(Trip*)trip {
    __block NSMutableArray *balanceAccounts = [[NSMutableArray alloc] init];
    [trip.accounts enumerateObjectsUsingBlock:^(Account *account, BOOL *stop) {
        [balanceAccounts addObject:[TripDatabase balanceForMember:member inAccount:account]];
    }];
    return balanceAccounts;
}

@end
