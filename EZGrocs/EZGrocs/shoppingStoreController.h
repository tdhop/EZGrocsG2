//
//  shoppingStoreController.h
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreInfoDelegate.h"

@interface shoppingStoreController : NSObject <StoreInfoDelegate>

@property (readonly) NSManagedObjectContext *storeInfoMOC; // Custom getter will create the MOC, registryStore, and userDataStore if it doesn't already exist
@property (readonly) NSPersistentStore *registryStore; // Custom getter will create the MOC, registryStore, and userDataStore if it doesn't already exist
@property (readonly) NSPersistentStore *userDataStore; // Custom getter will create the MOC, registryStore, and userDataStore if it doesn't already exist

@end
