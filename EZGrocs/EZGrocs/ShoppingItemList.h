//
//  ShoppingItemList.h
//  EZGrocs
//
//  Created by Tim Hopmann on 2/8/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListPortfolio, ShoppingItem;

@interface ShoppingItemList : NSManagedObject

@property (nonatomic, retain) NSString * listName;
@property (nonatomic, retain) NSSet *listMembers;
@property (nonatomic, retain) ListPortfolio *owningPortfolio;
@end

@interface ShoppingItemList (CoreDataGeneratedAccessors)

- (void)addListMembersObject:(ShoppingItem *)value;
- (void)removeListMembersObject:(ShoppingItem *)value;
- (void)addListMembers:(NSSet *)values;
- (void)removeListMembers:(NSSet *)values;

@end
