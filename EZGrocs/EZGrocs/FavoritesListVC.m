//
//  FavoritesListVC.m
//  
//
//  Created by Mark A Stewart on 1/31/14.
//
//

#import "FavoritesListVC.h"
#import "EZAppDelegate.h"

@interface FavoritesListVC ()

@end

@implementation FavoritesListVC

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
