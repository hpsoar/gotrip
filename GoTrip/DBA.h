//
//  TripDatabase.h
//  GoTrip
//
//  Created by Aldrich Huang on 04/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Utility.h"


@interface DBA : NSObject

- (id)initWithDatabaseName:(NSString *)name;

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entityName sortBy:(NSString *)key;

- (NSFetchedResultsController *)fetchedResultsControllerForFetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)path cacheName:(NSString *)cacheName;

- (NSFetchedResultsController *)fetchedResultsControllerForEntityName:(NSString *)entityName sortBy:(NSString *)key sectionNameKeyPath:(NSString *)path cacheName:(NSString *)cacheName;

- (id)insertNewObjectForEntityForName:(NSString *)databaseName;

- (NSArray *)executeFetchRequest:(NSFetchRequest *)fetchRequest;

- (void)deleteObject:(NSManagedObject *)object;
- (void)save;

@end
