//
//  SLShoppingListVC.h
//  ShoppingLib
//
//  Created by Tim Hopmann on 9/24/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SLShoppingListVC : UIViewController

@property (weak, nonatomic) NSManagedObjectContext *productTableContext; // set by AppDelegate after database has been initialized

@property BOOL shouldWaitForProceedMessage; // Set if this table cannot be loaded until SLShoppingListVC is sent a Proceed message.  Use this, for example, if SLShoppingListVC is the root view controller and has to wait for a database to be opened before it can reload table data.

@property (strong, nonatomic) NSString *cacheName;

@property (weak, nonatomic) IBOutlet UITableView *shoppingListTable;

- (void) proceed; // Tells SLShoppingListVC to proceed with loading the table data.  Used in conjunction with shouldWaitForProceedMessage.

- (void) initForSegue: (NSManagedObjectContext *) docContext shouldWait: (BOOL) waitFlag;

@property (strong, atomic) NSFetchedResultsController *shoppingListResultsController;

                    // If specified, used to set NSPredicate to filter the list.
@property (strong, atomic) NSString *filterDataInList;


@end
