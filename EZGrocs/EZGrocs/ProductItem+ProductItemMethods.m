//
//  ProductItem+ProductItemMethods.m
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "ProductItem+ProductItemMethods.h"
#import "StoreSection.h"

@implementation ProductItem (ProductItemMethods)

- (NSString *) sectionName {
    
    StoreSection *mySection = [self.sectionInfo lastObject];
    
    return mySection.sectionName;
}


- (int) sectionSequenceID {
    
    StoreSection *mySection = [self.sectionInfo lastObject];
    
    return [mySection.sectionSequenceID intValue];
}

@end
