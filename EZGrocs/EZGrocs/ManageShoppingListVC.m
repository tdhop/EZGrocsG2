//
//  ManageShoppingListVC.m
//  EZGrocs
//
//  Created by Mark A Stewart on 1/31/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "ManageShoppingListVC.h"
#import "ShoppingStoreController.h"
#import "ProductItem.h"

@interface ManageShoppingListVC ()

@property (strong, atomic) ShoppingStoreController *shoppingStoreCtrl;

@end

@implementation ManageShoppingListVC

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
                    /* If no Object Context, get a Managed Obj Context, set property for SLShoppingListVC class and proceed with table initialization.
                    */
    if (self.productTableContext == 0)
    {
        ShoppingStoreController *shoppingStoreCtrl = [[ShoppingStoreController alloc] init];
        self.productTableContext=shoppingStoreCtrl.storeInfoMOC;
        if (self.productTableContext != 0)
        {
            self.shouldWaitForProceedMessage=FALSE;
            [self proceed];
        }
        else
        {
            // mas self.shouldWaitForProceedMessage=TRUE;
                    /* Temp hack so unintialized MOC doesn't suspend app*/
            self.shouldWaitForProceedMessage=FALSE;
            NSLog(@"Hack in ManageShoppingListVC with mas comment needs to be removed");
        }
    }
    else if (self.shouldWaitForProceedMessage)
    {
        self.shouldWaitForProceedMessage=FALSE;
    }
                    /* Perform previous steps before invoking super ViewDidLoad
                       otherwise super ViewDidLoad concludes should proceed
                       prematurely as shouldWaitForProceedMessage property
                       defaults to FALSE.
                     */
    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
                    /* Get shopping list item pointed to by indexpath and configure the cell - item name and notes.
                    */
    // ProductItem *product = [self.shoppingListResultsController objectAtIndexPath:indexPath];
    // UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    // nameLabel.text = [NSString stringWithFormat:@"%@ - %@ - %@", product.itemName, product.sectionName, product.sectionIndex];
    UILabel *notesLabel = (UILabel *)[cell viewWithTag:2];
    notesLabel.text = @"3 jars of each";
    
    return cell;
}
                    // Support Delete for Edit style
- (void)editRow:(UIBarButtonItem *)sender
{
    if (self.editing)
    {
        sender.title = @"Edit";
        sender.style = UIBarButtonItemStylePlain;
        [super setEditing:NO animated:YES];
        [self.shoppingListTable setEditing:NO animated:YES];
    } else
    {
        sender.title = @"Done";
        sender.style = UIBarButtonItemStyleDone;
        [super setEditing:YES animated:YES];
        [self.shoppingListTable setEditing:YES animated:YES];
    }
}
                    /* Override to support editing table view on swipe and perform
                       action to delete the shopping list item from the list.
                    */

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog (@"Do delete");
    }
                    // Not currently supporting Insert style.
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"MngShopList: didselect row");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
