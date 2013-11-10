//
//  SectionParseDelegate.h
//  ezgconverter
//
//  Created by Mark A Stewart on 11/4/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionParseDelegate : NSObject

- (void) parseSectionsWithMutableArray: (NSMutableArray *) sectionArray;
- (void) setManagedObjectContext:(NSManagedObjectContext *) mngObjContext;

@end
