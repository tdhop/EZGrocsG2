//
//  ShoppingStoreController.h
//  EZGrocs
//
//  Created by Tim Hopmann on 3/6/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreInfoDelegate.h"

@interface ShoppingStoreController : NSObject <StoreInfoDelegate>

@property (readonly) NSManagedObjectContext *storeInfoMOC;  // Custom getter that will either create/return or will return if it already exists
@property (readonly) NSPersistentStore *registryStore; // Custom getter that will either create/return or will return if it already exists
@property (readonly) NSPersistentStore *userDataStore; // Custom getter that will either create/return or will return if it already exists

@end
