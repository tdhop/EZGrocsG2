//
//  ShoppingListController.m
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "ShoppingListController.h"
#import "StoreInfoDelegate.h"
#import "ConsumerNotes.h"

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

- (ShoppingItem *) createNewItemInMOC: MOC // Convenience method for internal use only - create new item and add to my list
{
        // Create new item
    ShoppingItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"ShoppingItem" inManagedObjectContext:MOC];
    
        // Assign new item to my list (set both ends of relationship)
    [self.myShoppingItemList addListMembersObject:newItem];
    newItem.owningList = self.myShoppingItemList;
    
        // Create a Consumer Notes instance and assign to new item
    newItem.notes = [NSEntityDescription insertNewObjectForEntityForName:@"ConsumerNotes" inManagedObjectContext:MOC];
    
    return newItem;
}

    // Create new item and stage it for add

 - (ShoppingItem *) stageNewItemForAdd
{
        // Note that the new ProductItem in UserData will need to be created when committing this item for add
    
    NSManagedObjectContext *MOC = [self.myStoreInfoDelegate storeInfoMOC];
    
        // Create new item
    ShoppingItem *newItem = [self createNewItemInMOC:MOC];
    
            // Mark new item as having been created by the user
    newItem.userItemFlag = [NSNumber numberWithBool:YES];
    
        // Set quantity to 1 (default value)
    newItem.quantity = [NSNumber numberWithInt:1];
    
    return newItem;
    
}

- (ShoppingItem *) stageItemForAdd:(ProductItem *)item
{
    NSManagedObjectContext *MOC = [self.myStoreInfoDelegate storeInfoMOC];
    
        // Create new item
        // Create new item
    ShoppingItem *newItem = [self createNewItemInMOC:MOC];
    
        // Copy all Product Item attributes
    newItem.itemName = item.itemName;
    newItem.sectionID = item.sectionID;
    newItem.userItemFlag = item.userItemFlag;
    
        // IF staging a ShoppingItem (as opposed to a ProductItem), do the right thing with ShoppingItem attributes
    if ([item isKindOfClass: [ShoppingItem class]]) {
            // Copy item's notes
        ConsumerNotes *newItemNotes = (ConsumerNotes *) newItem.notes;
        ConsumerNotes *itemNotes = (ConsumerNotes *) newItemNotes;
        newItemNotes.text = itemNotes.text;
        
            // Clear couponFlag
        newItem.couponFlag = [NSNumber numberWithBool:NO];
        
            // Set quantity to default value of 1
        newItem.quantity = [NSNumber numberWithInt:1];
    }
    
    return  newItem;
}

    // IMPLEMENT COMMITADDFORITEM
    // IMPLEMENT CANCELADDFORITEM
    // IMPLEMENT DELETE ITEM


@end
