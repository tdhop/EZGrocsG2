//
//  StoreInfoDelegate.h
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@protocol StoreInfoDelegate <NSObject>

@required

@property (readonly) NSManagedObjectContext *storeInfoMOC;
@property (readonly) NSPersistentStore *registryStore;
@property (readonly) NSPersistentStore *userDataStore;


@end
