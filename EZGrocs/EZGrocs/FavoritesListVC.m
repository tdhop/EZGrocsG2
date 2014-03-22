//
//  FavoritesListVC.m
//  
//
//  Created by Mark A Stewart on 1/31/14.
//
//

#import "FavoritesListVC.h"
#import "AddFromListVC.h"

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
    
                    // Do additional setup after loading view.
    
    self.shoppingListTable.dataSource = self;
    self.shoppingListTable.delegate =  self;
}

- (IBAction)tapEdit:(id)sender
{
    [self editRow:(UIBarButtonItem *)sender];
}

- (IBAction)tapAdd:(id)sender
{
    [self performSegueWithIdentifier:@"AddItemToFavoriteList" sender:self];
}

                    // Prepare for segue to Add
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddFromListVC *addFromListVC=segue.destinationViewController;
    [addFromListVC initForSegue:self workingList:FAVORITES_LIST];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
