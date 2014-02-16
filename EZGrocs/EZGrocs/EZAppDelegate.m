//
//  EZAppDelegate.m
//
//  Created by Tim Hopmann on 9/19/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//

#import "EZAppDelegate.h"
#import "SLShoppingListVC.h"

@interface EZAppDelegate()

@property (strong, nonatomic) UIManagedDocument *productRegistryManagedDoc;

@end

@implementation EZAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
        // The following is a dummy call to force the linker to load this particular class from my library.  Would not happen on its own because this class is only referenced through the class identifier in storyboard.  Linker does not 'see' that.
    //MAS [SLShoppingListVC class];  // Probably no longer necessary given some of the code below
    
        // Tell the ShoppingListVC that it should wait for proceed message given that we need to spend some time opening the database
    // mas SLShoppingListVC *slShoppingListVC = (SLShoppingListVC *)self.window.rootViewController;
    // mas slShoppingListVC.shouldWaitForProceedMessage = YES;
    
    
        // COPY THE PRODUCT REGISTRY SOURCE TO THE SANDBOX AND OPEN IT.  Using the name Vikings for the database just for fun.  Since this is a test app, it doesn't matter.
    
    /*  Get URL of Documents directory. It returns all matching
     directories in the domain but should only see one and it
     is in location 0 of the array (or "lastObject")
     */
    
    NSArray *tempURLs = [[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [tempURLs lastObject];
    
        // Change working directory to Documents and create "Vikings/StoreContent" directory in run-time environment.
    
    BOOL success = [[NSFileManager defaultManager] changeCurrentDirectoryPath:[documentsURL path]];
    NSLog(@"Change to Documents directory was successful? %d", success);
    
    success = [[NSFileManager defaultManager] createDirectoryAtPath:@"./VikingsDB/StoreContent" withIntermediateDirectories:YES attributes:nil error:nil];
    NSLog(@"Create new directory was successful? %d", success);
    
    /* Copy persistentStore into new directory from bundle. First build URL for file to be copied from bundle then build URL for file destination in Documents then copy file.
     */
    NSURL *copyFromURL = [[NSBundle mainBundle] resourceURL];
    copyFromURL = [copyFromURL URLByAppendingPathComponent:@"ProductRegistrySource"];
    NSLog(@"dbfile=%@", copyFromURL);
    NSURL *vikingsDestinationURL = [documentsURL URLByAppendingPathComponent:@"VikingsDB"];
    NSURL *copyToURL = [vikingsDestinationURL URLByAppendingPathComponent:@"StoreContent/persistentstore"];
    
    NSError *copyError; // This is there so it can be examined in debugger, otherwise not used
    success = [[NSFileManager defaultManager] copyItemAtURL:copyFromURL toURL:copyToURL error:&copyError];
    NSLog(@"File copy was successful? %d", success);
    
        // Allocate UIManagedDoc object pointer to VikingsDB and open file if exists.
    
    self.productRegistryManagedDoc = [[UIManagedDocument alloc] initWithFileURL:vikingsDestinationURL];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[vikingsDestinationURL path]])
    {
        [self.productRegistryManagedDoc openWithCompletionHandler:^(BOOL success)
         {
                 // File should have been copied from main bundle. If not there - PROBLEM!
             if (!success)
             {
                 NSLog(@"Couldn't open file at %@", vikingsDestinationURL);
             }
             else
             {
                 NSLog(@"file open success=%d", success);
             }
            [self registryDidOpen];
         }];
    } else NSLog(@"VikingsDB file not found");
    
    return YES;
}

- (void) registryDidOpen
{
                    /* Set VikingsDB context and save in App Delegate for use by
                       all View Controllers.
                    */
    self.productRegistryContext = self.productRegistryManagedDoc.managedObjectContext;
    
                    /* Use pointer to initial tab bar view controller to get to
                       first tab (should be a SLShoppingListVC) and call proceed
                       method since VC is waiting for the notification.
                    */
    
    UITabBarController *tabController = self.window.rootViewController;
    SLShoppingListVC *slSListVC=[[tabController viewControllers] objectAtIndex:0];
    NSLog(@"AppDelegate: Calling proceed");
    [slSListVC proceed];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
