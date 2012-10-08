//
//  Activity.h
//  GoTrip
//
//  Created by Aldrich Huang on 06/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Member, Pay, Trip;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *members;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) NSSet *pays;
@end

@interface Activity (CoreDataGeneratedAccessors)

- (void)addMembersObject:(Member *)value;
- (void)removeMembersObject:(Member *)value;
- (void)addMembers:(NSSet *)values;
- (void)removeMembers:(NSSet *)values;

- (void)addPaysObject:(Pay *)value;
- (void)removePaysObject:(Pay *)value;
- (void)addPays:(NSSet *)values;
- (void)removePays:(NSSet *)values;

@end
