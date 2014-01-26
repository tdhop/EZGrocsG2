//
//  EZAppDelegate.h
//  ShoppingLibTest
//
//  Created by Tim Hopmann on 9/19/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSManagedObjectContext *productRegistryContext;

                    /* Macros for entity names of supported lists. Created so
                       compiler can catch misspellings.
                    */
#define ACTIVE_REGISTRY_LIST "activeRegistryList"
#define ACTIVE_FAVORITES_LIST "activeFavoritesList"
#define ACTIVE_SHOPPING_LIST "activeShoppingList"

@end
