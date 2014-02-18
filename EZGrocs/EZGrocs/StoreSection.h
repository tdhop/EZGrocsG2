//
//  StoreSection.h
//  EZGrocs
//
//  Created by Tim Hopmann on 2/8/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StoreSection : NSManagedObject

@property (nonatomic, retain) NSNumber * sectionID;
@property (nonatomic, retain) NSString * sectionName;
@property (nonatomic, retain) NSNumber * sectionSequenceID;

@end
