//
//  ShoppingListController.h
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingItemList.h"
#import "ShoppingItem.h"
#import "StoreInfoDelegate.h"

@interface ShoppingListController : NSObject

@property (nonatomic, strong) ShoppingItemList *shoppingList;

    // Initialize new ShoppingListController
- (ShoppingListController *) initWithList: (ShoppingItemList *) newShoppingList andStoreInfoDelegate: (id <StoreInfoDelegate>) storeInfoDelegate;

    // Create new item and stage it for add
- (ShoppingItem *) stageNewItemForAdd; // Note that none of the attributes are defined but the item does have a blank ConsumerNotes object

    // Stage existing item for add. Existing item may be a ProductItem (came from Registry) or a ShoppingItem (came from Favorites list or Shopping list)
    // Note that staging involves creating a new ShoppingItem then copying appropriate attributes depending on scenario as follows:
    // 1. If item is a ProductItem, copy all attributes,
    // 2. If item is a ShoppingItem, copy all ProductItem attributes and copy notes but clear quantity, couponFlag, and set owningList to current list.
- (ShoppingItem *) stageItemForAdd: (ProductItem *) item;

    // Set up relationships with list, save item to persistent store; create new ProductItem if needed
- (void) commitAddForItem: (ShoppingItem *) stagedItem; // Note that the staged item AND any other unsaved changes will be committed!!!

    // Cancel add for item
- (void) cancelAddForItem: (ShoppingItem *) stagedItem; // Makes sure that ConsumerNotes object is deleted as well - should be taken care of by delete rule

    // Delete item from persistent store.    Returns YES if item was on my list, NO otherwise, no action taken if NO
- (BOOL) deleteItem: (ShoppingItem *) item;

@end
