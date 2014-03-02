//
//  PlanListVC.m
//  
//
//  Created by Mark A Stewart on 1/31/14.
//
//

#import "PlanListVC.h"
#import "EZAppDelegate.h"

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
}

                    // Configure count and coupon icon for table row.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
                    // Get cell for next row in table.
    
    UITableViewCell *cell = (UITableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}

                    // Invoke super method to implement Edit protocol
- (IBAction)tapEdit:(UIBarButtonItem *)sender
{
    [super editRow:(UIBarButtonItem *)sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
