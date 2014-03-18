//
//  ProductItem+ProductItemMethods.h
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "ProductItem.h"

@interface ProductItem (ProductItemMethods)

    // Note: DO NOT subclass these methods when inheriting from ProductItem.  Doing so may result in unpredictable behavior as the system may pick the wrong method (overridden vs. original) because we are using categories.

- (NSString *) sectionName; // Calculated by fetching property sectionInfo and retrieving name

- (void) setSectionName; // Fetches

- (int) sectionSequenceID; // Calculated by fetching property sectionInfo and retrieving sectionSequenceID

@end
