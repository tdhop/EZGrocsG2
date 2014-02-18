//
//  ConsumerNotes.h
//  EZGrocs
//
//  Created by Tim Hopmann on 2/8/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ShoppingItem;

@interface ConsumerNotes : NSManagedObject

@property (nonatomic, retain) NSNumber * maxLength;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) ShoppingItem *container;

@end
