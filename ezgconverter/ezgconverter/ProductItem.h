//
//  ProductItem.h
//  ezgconverter
//
//  Created by Mark A Stewart on 11/8/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProductItem : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * sectionName;
@property (nonatomic, retain) NSString * itemIdentifier;
@property (nonatomic, retain) NSNumber * sectionIndex;

@end
