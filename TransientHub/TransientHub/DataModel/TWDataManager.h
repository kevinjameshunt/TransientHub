//
//  TWDataManager.h
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-09.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TWDataManager : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (TWDataManager *)sharedDataManager;

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+ (void)cleanDataManager;
+ (NSManagedObjectModel *)managedObjectModel;

- (BOOL)saveChanges:(NSError **)error;
- (NSArray *)fetchData:(NSFetchRequest *)fetchRequest withError:(NSError **)error;

// Specific TransientHub methods
- (int)getNumberOfFeeds;

// Internal data manager methods
- (void)dumpAllManagedObjects;
- (void)dumpAllEvents;
- (void)dumpAllFeeds;

@end
