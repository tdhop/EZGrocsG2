//
//  SLShoppingListVC.m
//  ShoppingLib
//
//  Created by Tim Hopmann on 9/24/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//

/* IMPLEMENTATION NOTES
 
 Implementation of shouldWaitForProceedMessage
    * Requires code in viewWillAppear, viewDidAppear, and proceed as follows:
        - viewWillAppear just reloads data if there is no need to wait BUT if need to wait then it adds a spinner IF proceed has not yet run
        - proceed removes the spinner if called by the application code (doesn't mean anything if spinner isn't there in the first place) then reloads data, flashes the scrollbar, and sets a flag saying proceed has run (flag is set first - see comments in proceed to understand why)
        - viewDidAppear ALWAYS flashes the scrollbar
        -- Net effect is that all will run fine with one very minor exception: if proceed begins to execute but viewDidAppear jumps in on another thread before it finishes, then the scroll bar will either flash extra long or perhaps flash twice.
 
 */

#import <CoreData/CoreData.h>
#import "SLShoppingListVC.h"
#import "LabeledSpinnerView.h"
#import "ProductItem.h"
#import "StoreSection.h"

@interface SLShoppingListVC ()

@property (strong, nonatomic) LabeledSpinnerView *spinnerView;
@property BOOL proceedComplete;

@end

@implementation SLShoppingListVC


- (void) initForSegue: (NSManagedObjectContext *) docContext shouldWait: (BOOL) waitFlag cache: (NSString *) cacheName {
    self.productTableContext = docContext;
    self.shouldWaitForProceedMessage = waitFlag;
    self.cacheName = cacheName;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

        // Optionally add configurable static header at top of table
        // TEST CODE - for now, just add a table header
    /* CGRect tableHeaderFrame = CGRectMake(0, 0, 320, 20);
    UIView *tableHeader = [[UIView alloc] initWithFrame:tableHeaderFrame];
    tableHeader.backgroundColor = [UIColor magentaColor];
    CGRect tableHeaderLabelFrame = CGRectMake(20, 3, 280, 14);
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:tableHeaderLabelFrame];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = @"Table Header";
    [tableHeader addSubview:headerLabel];
    self.shoppingListTable.tableHeaderView = tableHeader;
    self.shoppingListTable.separatorColor = [UIColor blueColor]; */
        // END TEST CODE
    
                    /* IF NOT SHOULDWAIT: Send 'proceed' message to self; otherwise
                       wait for proceed message
                     */
    if (!self.shouldWaitForProceedMessage)
    {
        [self proceed];
    }
}

/* - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *uiSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];
    [uiSection setBackgroundColor:[UIColor cyanColor]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, 320, 20)];
    id <NSFetchedResultsSectionInfo> sectionInfo=[[self.shoppingListResultsController sections] objectAtIndex:section];
    headerLabel.text = sectionInfo.name;
    headerLabel.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:(CGFloat)15];
    [uiSection addSubview:headerLabel];
    return uiSection;
} */

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    id <NSFetchedResultsSectionInfo> sectionInfo=[[self.shoppingListResultsController sections] objectAtIndex:section];
    return (sectionInfo.name);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
        // Check to see if I should wait for proceed message AND proceed message has not yet been received
    NSLock *viewWillAppearLock = [NSLock new];
    
        // Lock to ensure that proceed doesn't run in the middle of this code
    [viewWillAppearLock lock];
    
    if (self.shouldWaitForProceedMessage && !self.proceedComplete) {
            // Add & start spinner with text "Loading"
        self.spinnerView = [[LabeledSpinnerView alloc] initWithStyle: LabeledSpinnerCenter];
        self.spinnerView.spinnerText = @"Loading...";
        [self.spinnerView start];
        [self.view addSubview:self.spinnerView];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    } else {
            // In this case either I needn't wait OR proceed has already run so I should just reload data
        self.shoppingListTable.dataSource = (id <UITableViewDataSource>) self;
        self.shoppingListTable.delegate = (id <UITableViewDelegate>) self;
        [self.shoppingListTable reloadData];
    }
        // End of critical code segment - Unlock
    [viewWillAppearLock unlock];
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    
        // Make sure my superclass is happy
    [super viewDidAppear:animated];
    
        // Flash the scroll indicators
    [self.shoppingListTable flashScrollIndicators];
}

- (void) proceed
{
        // We're ready to go, take down the spinner view
    
        // Let other code know that this routine has run (note that this has to be up front so that if viewWillAppear jumps in before proceed removes the spinner then either viewWillAppear will never add it (because flag is set) or viewWillAppear will add it and proceed will immediately remove it.
    self.proceedComplete = YES;
    
    [self.spinnerView removeFromSuperview];
        // Now release the spinner view object
    self.spinnerView = nil;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    

    
        // Now flash the scroll bar
    [self.shoppingListTable flashScrollIndicators];
    
        // Create Fetch Request
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ProductItem"];
        // Sort by the itemName attribute
    NSSortDescriptor *sectionSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sectionIndex" ascending:YES];
    NSSortDescriptor *itemSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"itemName" ascending:YES];
        // Add sort descriptor to Fetch Request
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sectionSortDescriptor, itemSortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
                    // Set predicate if property set.
    if (self.filterDataInList != nil)
    {
        NSPredicate *pred = [NSPredicate predicateWithFormat:self.filterDataInList];
        [fetchRequest setPredicate:pred];
    }
    
        // Now create FRC with Fetch Request
    self.shoppingListResultsController = [[NSFetchedResultsController alloc]
                                          initWithFetchRequest:fetchRequest
                                          managedObjectContext:self.productTableContext
                                          sectionNameKeyPath:@"sectionIndex"
                                          cacheName:self.cacheName];
    
        // TEST CODE
    [self.shoppingListResultsController performFetch:nil];
        // END TEST CODE
    
        // Now that everything is ready to go, set data source and tell the tableview to reload
    self.shoppingListTable.dataSource = self;
    self.shoppingListTable.delegate = self;
    [self.shoppingListTable reloadData];
}

- (void)didReceiveMemoryWarning
{
        // [super didReceiveMemoryWarning]; Must be sub-classed since UIView does not implement this method.
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    NSInteger count;
    count = [[self.shoppingListResultsController sections] count];
    return count; // count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([[self.shoppingListResultsController sections] count] > 0)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.shoppingListResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    ProductItem *product = [self.shoppingListResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = product.itemName;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"in didSelectRow");
}

@end
