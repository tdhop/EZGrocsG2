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
#import "ShoppingEntityNames.h"

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

    // Set up relationships with list, save item to persistent store; create new ProductItem if needed
- (void) commitAddForItem: (ShoppingItem *) stagedItem // Note that the staged item AND any other unsaved changes will be committed!!!
{
    
    NSManagedObjectContext *MOC = [self.myStoreInfoDelegate storeInfoMOC];

        // Find out if this is a user-created item - if so, create a new ProductItem and copy attributes
    if ([stagedItem.userItemFlag boolValue]) {
            // create new ProductItem and put it in the userDataStore so that it will show up in future registry searches
        ProductItem *newProductItem = [NSEntityDescription insertNewObjectForEntityForName:PRODUCT_ITEM inManagedObjectContext:MOC];
            // make sure the item is assigned to the right persistent store
        [MOC assignObject:newProductItem toPersistentStore:[self.myStoreInfoDelegate userDataStore]];
            // copy attributes
        newProductItem.itemName = stagedItem.itemName;
        newProductItem.sectionID = stagedItem.sectionID;
        newProductItem.userItemFlag = stagedItem.userItemFlag;
    }
    
        // Now set up the reciprocal relationships between stagedItem and the list I am controlling
        // First, add stagedItem to the to-many relationship on the list
    [self.myShoppingItemList addListMembersObject:stagedItem];
        // Now, add this list to the to-one relationship on stagedItem
    stagedItem.owningList = self.myShoppingItemList;
    
    
        // Now do a save operation on the MOC which will save the newProductItem, the stagedItem, and anything else that happens to be hanging around in the cache (which should be nothing given our app design)
    [MOC save:nil]; // Note that there is no error processing here.  If we start seeing problems we may eventually want to process the error in an intelligent manner
    
}


    // Cancel add for item
- (void) cancelAddForItem: (ShoppingItem *) stagedItem // Makes sure that ConsumerNotes object is deleted as well - should be taken care of by delete rule
{
    
    NSManagedObjectContext *MOC = [self.myStoreInfoDelegate storeInfoMOC];
    
        // Delete ConsumerNotes object
    [MOC deleteObject:stagedItem.notes];
        // Delete stagedItem
    [MOC deleteObject:stagedItem];
    
}


    // Delete item from persistent store and save (commit)
- (void) deleteItem: (ShoppingItem *) item
{
    
    NSManagedObjectContext *MOC = [self.myStoreInfoDelegate storeInfoMOC];

        // Delete ConsumerNotes object
    [MOC deleteObject:item.notes];
        // Delete stagedItem
    [MOC deleteObject:item];
    
        // now save (commit)
    [MOC save:nil];
}

@end
