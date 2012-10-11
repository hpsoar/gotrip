//
//  SubAccount.h
//  GoTrip
//
//  Created by Aldrich Huang on 11/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Member;

@interface SubAccount : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * isAA;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) Member *owner;

@end
