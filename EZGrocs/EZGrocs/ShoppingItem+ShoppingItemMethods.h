//
//  ShoppingItem+ShoppingItemMethods.h
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "ShoppingItem.h"
#import "ConsumerNotes.h"

@interface ShoppingItem (ShoppingItemMethods)

- (void) initWithSectionID: (NSNumber *) sectionID andNote: (ConsumerNotes *) userNote;

@end
