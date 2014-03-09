//
//  ManageShoppingListVC.h
//  EZGrocs
//
//  Created by Mark A Stewart on 1/31/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "SLShoppingListVC.h"

@interface ManageShoppingListVC : SLShoppingListVC

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void) editRow: (UIBarButtonItem *) sender;

@property(nonatomic, assign) int listName;

                    // Used to determine list user is currently working on.
#define SHOPPING_LIST   1
#define FAVORITES_LIST  2

@end
