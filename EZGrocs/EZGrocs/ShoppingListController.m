//
//  ShoppingListController.m
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "ShoppingListController.h"

@interface ShoppingListController ()

@property (nonatomic, strong) ShoppingItemList *myShoppingItemList;
@property (nonatomic, strong) id <StoreInfoDelegate> myStoreInfoDelegate;

@end

@implementation ShoppingListController

    // Initialize new ShoppingListController; the ShoppingListController will get the managed object context and Registry/UserData store information from the storeInfoDelegate
- (ShoppingListController *) initWithList: (ShoppingItemList *) newShoppingList andStoreInfoDelegate: (id <StoreInfoDelegate>) storeInfoDelegate
{
    self = [super init];
    
    self.myShoppingItemList = newShoppingList;
    
    self.myStoreInfoDelegate = storeInfoDelegate;
    
    return self;
}

    // Create new item and stage it for add
/* 
 - (ShoppingItem *) stageNewItemForAdd
{
    
}
 */

@end
