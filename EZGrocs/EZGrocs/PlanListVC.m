//
//  PlanListVC.m
//  
//
//  Created by Mark A Stewart on 1/31/14.
//
//

#import "PlanListVC.h"
#import "AddFromListVC.h"

// temp
#import "ShoppingListController.h"

@interface PlanListVC ()

@end

@implementation PlanListVC

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
    
                    // Temp
   /* NSLog (@"MOC=%@",self.shoppingStoreCtrl.storeInfoMOC);
    id newItem = [NSEntityDescription insertNewObjectForEntityForName:@"ShoppingItemList" inManagedObjectContext:self.shoppingStoreCtrl.storeInfoMOC];
    
    ShoppingItemList *sIList = newItem;
    sIList.listName = @"PlanList";
    NSLog(@"silist = %@",sIList);
    ShoppingListController *slController = [[ShoppingListController alloc] initWithList:sIList andStoreInfoDelegate:self.shoppingStoreCtrl];
    ShoppingItem *shopItem1 = [slController stageNewItemForAdd];
    shopItem1.itemName=@"PopTarts";
    shopItem1.sectionID=[NSNumber numberWithInt:3];
    NSLog(@"shop item = %@",shopItem1);
    [slController commitAddForItem:shopItem1];
    ShoppingItem *shopItem2 = [slController stageNewItemForAdd];
    shopItem2.itemName=@"CornFlakes";
    shopItem2.sectionID=[NSNumber numberWithInt:3];
    [slController commitAddForItem:shopItem2];
    ShoppingItem *shopItem3 = [slController stageNewItemForAdd];
    shopItem3.itemName=@"Potatoes";
    shopItem3.sectionID=[NSNumber numberWithInt:2];
    [slController commitAddForItem:shopItem3]; */
}

                    // Configure count and coupon icon for table row.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
                    // Get cell for next row in table.
    
    UITableViewCell *cell = (UITableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}
- (IBAction)tapEdit:(id)sender
{
    [super editRow:(UIBarButtonItem *)sender];
}

- (IBAction)tapAdd:(id)sender
{
    [self performSegueWithIdentifier:@"AddItemToPlanList" sender:self];
}
                    // Prepare for segue to Add
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddFromListVC *addFromListVC=segue.destinationViewController;
    [addFromListVC initForSegue:self workingList:SHOPPING_LIST];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
