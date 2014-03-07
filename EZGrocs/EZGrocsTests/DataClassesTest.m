//
//  DataClassesTest.m
//  EZGrocs
//
//  Created by Tim Hopmann on 2/8/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProductItem+ProductItemMethods.h"
#import "ConsumerNotes.h"
#import "StoreSection.h"
#import "ShoppingItem.h"
#import "ShoppingItemList.h"
#import "ListPortfolio.h"

@interface DataClassesTest : XCTestCase

@property NSManagedObjectContext *testMOC;
@property NSString *testString;
@property NSNumber *testInteger;
@property NSNumber *testBool;
@property NSURL *registryURL;
@property NSURL *userDataURL;

@end

@implementation DataClassesTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
        // Get Managed Object Model - note that we don't have to merge models because we just built it all into one model in the first place (yeah!)
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle mainBundle]]];
        // Create a persistent store coordinator - below we will create two different stores and add them to the one PSC to simulate Registry and UserData files
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
        // Create bogus URLs for Registry and UserData
    self.registryURL = [NSURL URLWithString:@"file://inMemReg"];
    self.userDataURL = [NSURL URLWithString:@"file://inMemUData"];
        // Add in-memory store that will be used in tests as the Registry store -- Uses bogus URL: self.registryURL
    XCTAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:@"RegistryConfig" URL:self.registryURL options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
        // Add in-memory store that will be used in tests as the UserData store -- Uses bogus URL: self.userDataURL
    XCTAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:@"UserDataConfig" URL:self.userDataURL options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    
    
    
    self.testMOC = [[NSManagedObjectContext alloc] init];
    self.testMOC.persistentStoreCoordinator = psc;
    
        //Set up numbers for test
    self.testInteger = [NSNumber numberWithInt:5];
    self.testBool = [NSNumber numberWithBool:YES];
    self.testString = @"Test String";
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.testMOC=nil;
    self.testInteger = nil;
    self.testBool = nil;
    self.registryURL = nil;
    self.userDataURL = nil;
}

#pragma mark - Convenience Methods

    // Convenience: Create instance of entity
- (id) createInstanceOfEntity: (NSString *) entityName
{
    id newItem = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.testMOC];
    
    return newItem;
}

    // Convenience: Simulate FileInfoDelegate


- (void) testStoreSection
{
        //Set up StoreSection for test
    StoreSection *testSection = [self createInstanceOfEntity:@"StoreSection"];
    
        //Test properties
    testSection.sectionID = self.testInteger;
    XCTAssertEqualObjects(testSection.sectionID, self.testInteger, @"StoreSection failed to store sectionID");
    
    testSection.sectionName = @"Test Section";
    XCTAssertEqual(testSection.sectionName, @"Test Section", @"StoreSection failed to store Test Section");
    
    testSection.sectionSequenceID = self.testInteger;
    XCTAssertEqualObjects(testSection.sectionSequenceID, self.testInteger, @"StoreSection failed to store sectionSequenceID");
    

    NSLog(@"seqID=%@, testI=%@",testSection.sectionSequenceID,self.testInteger);
}

- (void) testProductItem
{
        //Set up ProductItem for test
        //ProductItem *testProduct = [NSEntityDescription insertNewObjectForEntityForName:@"ProductItem" inManagedObjectContext:self.testMOC];
    ProductItem *testProduct = [self createInstanceOfEntity:@"ProductItem"];
    
        //Test properties
    testProduct.itemName = @"testName";
    XCTAssertEqualObjects(testProduct.itemName, @"testName", @"ProductItem failed to store itemName");
    
    testProduct.sectionID = self.testInteger;
    XCTAssertEqualObjects(testProduct.sectionID, self.testInteger, @"ProductItem failed to store sectionID");
    
    testProduct.userItemFlag = self.testBool;
    XCTAssertEqualObjects(testProduct.userItemFlag, self.testBool, @"ProductItem failed to store userItemFlag");
    
        //Create a StoreSection so it can be retrieved
    StoreSection *testSection = [self createInstanceOfEntity:@"StoreSection"];
    testSection.sectionID = self.testInteger;
    testSection.sectionName = self.testString;
    testSection.sectionSequenceID = self.testInteger;
    
    
        //Test fetched properties
    NSArray *sections =[testProduct valueForKey:@"sectionInfo"];
    XCTAssert([sections count] == 1, @"Product Item did not return proper number of StoreSections from fetched property sectionInfo");
    
    StoreSection *sectionForTestProduct = [sections lastObject];
    XCTAssertNotNil(sectionForTestProduct, @"ProductItem failed to return fetched property 'sectionInfo'");
    
        //Tear down fetched properties test
    sections = nil;
    sectionForTestProduct = nil;
    
        //Test calculated getters
    XCTAssertEqualObjects([testProduct sectionName], self.testString, @"StoreSection for TestProduct did not correctly store string");
    XCTAssertEqual([testProduct sectionSequenceID], [self.testInteger intValue]);
    
}

- (void) testFetch
{
        // Put a ProductItem in both Registry and UserData and a ShoppingItem in UserData
        //Get Persistent Store objects
    NSPersistentStore *registryStore = [self.testMOC.persistentStoreCoordinator persistentStoreForURL:self.registryURL];
    NSPersistentStore *userDataStore = [self.testMOC.persistentStoreCoordinator persistentStoreForURL:self.userDataURL];
    
        // Create an in-memory test product in testMOC - it will stay in mem until [MOC save:], assign it to the Registry store,
    ProductItem *testRegProduct = [self createInstanceOfEntity:@"ProductItem"];
    testRegProduct.sectionID = [NSNumber numberWithInteger:1];
    [self.testMOC assignObject:testRegProduct toPersistentStore:registryStore];
    
        // Create an in-memory test product in testMOC - it will stay in mem until [MOC save:], assign it to the Registry store,
    ProductItem *testUDataProduct = [self createInstanceOfEntity:@"ProductItem"];
    testUDataProduct.sectionID = [NSNumber numberWithInteger:2];
    [self.testMOC assignObject:testUDataProduct toPersistentStore:userDataStore];

        // Create an in-memory test shopping item in testMOC - it will stay in mem until [MOC save:], assign it to the UserData store,
    ShoppingItem *testShop = [self createInstanceOfEntity:@"ShoppingItem"];
    testShop.sectionID = [NSNumber numberWithInteger:3];
    [self.testMOC assignObject:testShop toPersistentStore:userDataStore];
    
    [self.testMOC save:nil];
    
        // Now check to see if any of these objects have been saved to the store -- should not be
    NSDictionary *vals = [testUDataProduct committedValuesForKeys:nil];  // returns a dictionary containing last saved values for all keys given nil at end
    XCTAssertEqual([vals count], (NSUInteger)3, @"testUDataProduct was saved but should not have been");

        // Now fetch all Product Items and see what I get back
    
    NSFetchRequest *productFetch = [NSFetchRequest fetchRequestWithEntityName:@"ProductItem"];
    [productFetch setIncludesSubentities:NO];
    NSArray *fetchReturn = [self.testMOC executeFetchRequest:productFetch error:nil];
    
    XCTAssertEqual([fetchReturn count], (NSUInteger)2, @"Didn't get entity + subentity");
}

@end
