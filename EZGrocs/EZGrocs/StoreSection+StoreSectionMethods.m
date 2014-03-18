//
//  StoreSection+StoreSectionMethods.m
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "StoreSection+StoreSectionMethods.h"

@implementation StoreSection (StoreSectionMethods)

+ (NSArray *) getStoreSectionsFrom: (NSManagedObjectContext *) managedObjectContext;
{
    NSFetchRequest *fetchSections = [NSFetchRequest fetchRequestWithEntityName:@"StoreSection"];
    
    NSArray *storeSections = [managedObjectContext executeFetchRequest:fetchSections error:nil];
    
    return storeSections;
}

@end
