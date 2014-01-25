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

@end
