//
//  ListPortfolio.h
//  EZGrocs
//
//  Created by Tim Hopmann on 2/8/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ListPortfolio : NSManagedObject

@property (nonatomic, retain) NSSet *portfolioMembers;
@end

@interface ListPortfolio (CoreDataGeneratedAccessors)

- (void)addPortfolioMembersObject:(NSManagedObject *)value;
- (void)removePortfolioMembersObject:(NSManagedObject *)value;
- (void)addPortfolioMembers:(NSSet *)values;
- (void)removePortfolioMembers:(NSSet *)values;

@end
