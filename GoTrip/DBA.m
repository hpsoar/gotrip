//
//  TripDatabase.m
//  GoTrip
//
//  Created by Aldrich Huang on 04/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "DBA.h"

@interface DBA ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSString *databaseName;
@end

@implementation DBA

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize databaseName = _databaseName;

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingFormat:@"%@.%@", self.databaseName, @"sqlite"];
        
        // here you can copy default data provided by Bundles to storePath
        NSURL *storeURL = [NSURL fileURLWithPath:storePath];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSError *error;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            /* Typical reasons for an error here include:
             * The persistent store is not accessible
             * The schema for the persistent store is incompatible with current managed object model
             * Check the error message to determine what the actual problem was.
             */
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext && self.persistentStoreCoordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _managedObjectContext;
}

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entityName sortBy:(NSString *)key {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:key ascending:YES]];
    return fetchRequest;
}

- (NSFetchedResultsController *)fetchedResultsControllerForFetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)path cacheName:(NSString *)cacheName {
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:path cacheName:cacheName];
    
    NSError *error;
    if (![controller performFetch:&error]) {
        [Utility logError:error];
        abort();
    }
    return controller;
}

- (NSFetchedResultsController *)fetchedResultsControllerForEntityName:(NSString *)entityName sortBy:(NSString *)key sectionNameKeyPath:(NSString *)path cacheName:(NSString *)cacheName {
    NSFetchRequest *fetchRequest = [self fetchRequestForEntity:entityName sortBy:key];
    return [self fetchedResultsControllerForFetchRequest:fetchRequest sectionNameKeyPath:path cacheName:cacheName];
}

- (id)insertNewObjectForEntityForName:(NSString *)name {
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext];
}

- (id)initWithDatabaseName:(NSString *)databaseName {
    self = [super init];
    self.databaseName = databaseName;
    return self;
}

- (void)deleteObject:(NSManagedObject *)object {
    [self.managedObjectContext deleteObject:object];
}

- (void)save {
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        [Utility logError:error];
        abort();
    }
}

@end
