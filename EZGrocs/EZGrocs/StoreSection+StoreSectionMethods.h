//
//  StoreSection+StoreSectionMethods.h
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "StoreSection.h"

@interface StoreSection (StoreSectionMethods)

+ (NSArray *) getStoreSectionsFrom: (NSManagedObjectContext *) managedObjectContext;

@end
