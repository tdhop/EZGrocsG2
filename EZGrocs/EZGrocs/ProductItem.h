//
//  ProductItem.h
//  EZGrocs
//
//  Created by Tim Hopmann on 2/8/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProductItem : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSNumber * sectionID;
@property (nonatomic, retain) NSNumber * userItemFlag;

    //Manually created reference to fetch property -- is not automatically created by Xcode
@property (nonatomic, retain) NSArray *sectionInfo;

@end
