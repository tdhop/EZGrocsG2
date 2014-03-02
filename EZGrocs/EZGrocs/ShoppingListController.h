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

    // Stage existing item for add
- (ShoppingItem *) stageItemForAdd: (ShoppingItem *) item;

    // Stage new new item for add
- (ShoppingItem *) stageNewUserDefinedItem; // Note that none of the attributes are defined but the item does have a blank ConsumerNotes object

    // Save item to persistent store
- (void) commitAddForItem: (ShoppingItem *) stagedItem; // Note that the staged item AND any other unsaved changes will be committed!!!

    // Cancel add for item
- (void) cancelAddForItem: (ShoppingItem *) stagedItem; // Makes sure that ConsumerNotes object is deleted as well - should be taken care of by delete rule

    // Delete item from persistent store
- (void) deleteItem: (ShoppingItem *) item;

@end
