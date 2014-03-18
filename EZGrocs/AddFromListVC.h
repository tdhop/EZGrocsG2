//
//  AddFromListVC.h
//  EZGrocs
//
//  Created by Mark A Stewart on 3/9/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "SLShoppingListVC.h"
#import "ManageShoppingListVC.h"
#import "ShoppingDetailView.h"

@interface AddFromListVC : SLShoppingListVC

- (void) initForSegue: (id) upstreamController
        workingList: (int) listId;

@property (strong,nonatomic) ShoppingDetailView *detailView;

@end
