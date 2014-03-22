//
//  AddFromListVC.m
//  EZGrocs
//
//  Created by Mark A Stewart on 3/9/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "AddFromListVC.h"
#import "ShoppingDetailView.h"

@interface AddFromListVC ()

@property (nonatomic,assign) int workListIdentifier;

@end

@implementation AddFromListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) initForSegue: (id) upstreamController
        workingList:(int)listId
{
                    // Save value of working list (adding to)
    
    self.workListIdentifier = listId;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

                    // Default is to retrieve Favorite List.
    
    if (self.workListIdentifier == SHOPPING_LIST)
    {
        NSLog(@"AddFromListVC: working list is Shopping List");
    }
    else
    {
        NSLog(@"AddFromListVC: working list is Favorites List");
    }
}
    
-(void) callBackFromSubView
{
        NSLog(@"Main view updateFromSubview called");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
                    /* Get shopping list item pointed to by indexpath and configure the cell with item name.
                     */
    // ProductItem *product = [self.shoppingListResultsController objectAtIndexPath:indexPath];
    // UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    // nameLabel.text = [NSString stringWithFormat:@"%@ - %@ - %@", product.itemName, product.sectionName, product.sectionIndex];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"MngShopList: didselect row");
}

- (IBAction)tapDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)tapListSelect:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    if (selectedSegment == 0)
    {
        NSLog(@"Favorite picker");
    }
    else
    {
        NSLog(@"Search picker");
    }
}

- (IBAction)tapSelectRow:(id)sender
{
    // MAS temp
    NSString *itemName = @"Lettuce";
    NSNumber *sectionNum = [NSNumber numberWithInt:1];
    NSLog(@"shopitem=%@, %@",itemName,sectionNum);
    // init somewhere offscreen, in direction should appear from
    self.detailView=[[ShoppingDetailView alloc]initWithFrame:CGRectMake(0, -240, 320, 280)];
    [self.detailView setUpView:itemName sectId:sectionNum];
    [self.detailView setDelegate:self];
    [self.view addSubview:self.detailView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    self.detailView.frame=CGRectMake(0,0, 320, 280);
    [UIView commitAnimations];
    NSLog(@"animated detail view");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
