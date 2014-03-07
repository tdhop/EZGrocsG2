//
//  ProductItem+ProductItemMethods.h
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "ProductItem.h"

@interface ProductItem (ProductItemMethods)

- (NSString *) sectionName; // Calculated by fetching property sectionInfo and retrieving name

- (int) sectionSequenceID; // Calculated by fetching property sectionInfo and retrieving sectionSequenceID

@end
