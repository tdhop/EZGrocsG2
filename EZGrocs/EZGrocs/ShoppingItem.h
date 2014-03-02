//
//  ShoppingItem.h
//  EZGrocs
//
//  Created by Tim Hopmann on 2/8/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ProductItem.h"


@interface ShoppingItem : ProductItem

@property (nonatomic, retain) NSNumber * couponFlag;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSManagedObject *notes;
@property (nonatomic, retain) NSManagedObject *owningList;

@end
