//
//  ItemParseDelegate.h
//  ezgconverter
//
//  Created by Mark A Stewart on 10/29/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCSVParser.h"

// Number of fields in the product registry
#define NUMFIELDS 56

// Names of fields in the product registry
#define ITEM_IDENTIFIER 0
#define ITEM_NAME 2
#define SECTION 3

@interface ItemParseDelegate : NSObject <CHCSVParserDelegate>

- (void) setManagedObjectContext:(NSManagedObjectContext *) mngObjContext;

@end
