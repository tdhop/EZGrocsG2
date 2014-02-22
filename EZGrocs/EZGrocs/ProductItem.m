//
//  ProductItem.m
//  EZGrocs
//
//  Created by Tim Hopmann on 2/8/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "ProductItem.h"


@implementation ProductItem

@dynamic itemName;
@dynamic sectionID;
@dynamic userItemFlag;

    //Manually added fetched property because Xcode does not automatically do so
@dynamic sectionInfo;


#pragma mark - Methods

+ (ProductItem *) newWithItemName: (NSString *) itemName section: (NSString *) sectionName managedObjectContext: (NSManagedObjectContext *) moc {
        // Create new ProductItem object with itemName and sectionName and return to caller
    ProductItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"ProductItem" inManagedObjectContext:moc];
    
    newItem.itemName = itemName;
    
        // How do I want to set store section?  Passing section name is really not that helpful.  What I really need is to get the section ID - which the caller could provide to me (not sure I like that solution) or I could retrieve it here by fetching the StoreSection that matches the name I'm given.  Question is, should the rest of the code deal primarily in section names (NO - they may change with time and if internationalized we do not want these strings in English) or in section IDs (YES - but how does the rest of the code know the section ID? -- presumably from the spinner that the consumer uses to set the section name when creating a new item - ??)
    
    return newItem;
    
}





@end
