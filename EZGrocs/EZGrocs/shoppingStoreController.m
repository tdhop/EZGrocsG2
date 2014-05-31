//
//  ShoppingStoreController.m
//  EZGrocs
//
//  Created by Tim Hopmann on 3/6/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "ShoppingStoreController.h"

@implementation ShoppingStoreController

@synthesize storeInfoMOC = _storeInfoMOC;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSManagedObjectContext *) storeInfoMOC
{
    if (_storeInfoMOC == nil)
    {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        _storeInfoMOC = [[NSManagedObjectContext alloc] init];
        [_storeInfoMOC setPersistentStoreCoordinator:coordinator];
    }
    return _storeInfoMOC;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EZGrocs" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil)
    {
        NSArray *tempURLs = [[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *userDataURL = [[tempURLs lastObject] URLByAppendingPathComponent:@"Datafiles/UserData"];
        NSURL *registryURL = [[tempURLs lastObject] URLByAppendingPathComponent:@"Datafiles/Registry"];
    
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        self.userDataStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:@"UserDataConfig" URL:userDataURL options:nil error:nil];
        if (!self.userDataStore)
        {
            NSLog(@"persistentStoreCoord: Unresolved error %@, %@, %@", error, [error userInfo],userDataURL);
            abort();
        }
        
        // Need to understand how to open readonly first time.
        // NSDictionary *storeOptions =[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:1]forKey:NSReadOnlyPersistentStoreOption];
        
        self.registryStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:@"RegistryConfig" URL:registryURL options:nil error:nil];
        if (!self.registryStore)
        {
            NSLog(@"persistentStoreCoord: Unresolved error %@, %@, %@", error, [error userInfo],registryURL);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}
@end
