//
//  FavoritesVC.m
//  EZGrocs
//
//  Created by Mark A Stewart on 1/18/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "FavoritesVC.h"
#import "EZAppDelegate.h"



@interface FavoritesVC ()

@end

@implementation FavoritesVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
                    /* Get Managed Obj Context property from AppDelegate and set
                       property in SLShoppingListVC class.
                    */
    
    EZAppDelegate *myAppDelegate = [[UIApplication sharedApplication] delegate];
    self.productTableContext=myAppDelegate.productRegistryContext;
    NSLog(@"MFVC:VDL MOC=%@",self.productTableContext);
    
                    /* If no Object Context, app delegate not finished loading, so wait. If loading finished and were waiting, cancel wait.
                    */
    
    if (self.productTableContext == 0)
    {
        self.shouldWaitForProceedMessage=TRUE;
    }
    else if (self.shouldWaitForProceedMessage)
    {
        self.shouldWaitForProceedMessage=FALSE;
    }
                    /* Perform previous steps before calling super ViewDidLoad
                       otherwise super ViewDidLoad will conclude should proceed
                       prematurely since shouldWaitForProceedMessage property will
                       default to FALSE.
                    */
    [super viewDidLoad];
    
    NSLog(@"MFVC: VDL: title=%@", self.title);
}

- (void) proceed
{
    EZAppDelegate *myAppDelegate = [[UIApplication sharedApplication] delegate];
    self.productTableContext=myAppDelegate.productRegistryContext;
    
    NSLog(@"FavVC: proceed: MOC=%@",self.productTableContext);
    
    [super proceed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
