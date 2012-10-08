//
//  Member.h
//  GoTrip
//
//  Created by Aldrich Huang on 06/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pay;

@interface Member : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * qq;
@property (nonatomic, retain) NSSet *pays;
@end

@interface Member (CoreDataGeneratedAccessors)

- (void)addPaysObject:(Pay *)value;
- (void)removePaysObject:(Pay *)value;
- (void)addPays:(NSSet *)values;
- (void)removePays:(NSSet *)values;

@end
