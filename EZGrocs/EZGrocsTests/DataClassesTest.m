//
//  DataClassesTest.m
//  EZGrocs
//
//  Created by Tim Hopmann on 2/8/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProductItem+ProductItemMethods.h"
#import "ShoppingItem.h"
#import "ConsumerNotes.h"
#import "StoreSection+StoreSectionMethods.h"
#import "ShoppingItemList.h"
#import "ConsumerNotes+ConsumerNotesMethods.h"
#import "ListPortfolio.h"

@interface DataClassesTest : XCTestCase

@property NSManagedObjectContext *testMOC;
@property NSString *testString;
@property NSNumber *testInteger;
@property NSNumber *testBool;
@property NSString *testNoteString;
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
    self.testNoteString = @"This is a Consumer Note";
    
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
    
        //Test convenience method to retrieve all store sections
        //First, test to see that just one comes back
    NSArray *storeSections = [StoreSection getStoreSectionsFrom:self.testMOC];
    XCTAssertEqual([storeSections count], 1, @"Attempt to get all store sections returned the wrong number of results");

        // Now put a second section in the DB
    StoreSection *testSection2 = [self createInstanceOfEntity:@"StoreSection"];
    testSection2.sectionName = @"Second Test Section";
        //Now retrieve all sections
    storeSections = [StoreSection getStoreSectionsFrom:self.testMOC];
    XCTAssertEqual([storeSections count], 2, @"Attempt to get all store sections returned the wrong number of results");

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

- (void) testConsumerNotes
{
    /* Test these two methods:
     - (NSString *) getTruncated: (int) lengthInChars;
     
     - (NSString *) getTruncatedWithEllipsis: (int) lengthInChars; // Will return notes truncated to lengthInChars-3 with appended "..."
     */
    
        // Get a ConsumerNotes instance
    ConsumerNotes *testNotes = [self createInstanceOfEntity:@"ConsumerNotes"];
    
        // Put a test string into it
    testNotes.text = @"This is a string with 41 characters in it";
    
        // Now get a truncated version 35 characters -- should read "This is a string with 41 characters"
    NSString *truncatedText = [testNotes getTruncated:35];
    XCTAssertEqualObjects(truncatedText, @"This is a string with 41 characters", @"getTruncated did not return the correct string");
    
        // Now get a truncated version with ellipsis and 38 characters -- should read "This is a string with 41 characters..."
    truncatedText = [testNotes getTruncatedWithEllipsis:38];
    XCTAssertEqualObjects(truncatedText, @"This is a string with 41 characters...", @"getTruncatedWithEllipsis did not return the correct string");

}

- (void) testShoppingItem
{
        // Set up item for test
    ShoppingItem *testShoppingItem = [self createInstanceOfEntity:@"ShoppingItem"];
    
        // Make sure that inheritance is working (duh).  If one property works, they'll all work
    testShoppingItem.itemName = @"testName";
    XCTAssertEqualObjects(testShoppingItem.itemName, @"testName", @"ShoppingItem failed to store itemName");
    
        // Test added attributes
    testShoppingItem.couponFlag = self.testBool;
    XCTAssertEqualObjects(testShoppingItem.couponFlag, self.testBool, @"ShoppingItem failed to store couponFlag");
    
    testShoppingItem.quantity = self.testInteger;
    XCTAssertEqualObjects(testShoppingItem.quantity, self.testInteger, @"ShoppingItem failed to store quantity");
    
        // Create ConsumerNotes object so I can test the 'notes' attribute
    ConsumerNotes *tempNotes = [self createInstanceOfEntity:@"ConsumerNotes"];
    tempNotes.text = self.testNoteString;
    testShoppingItem.notes = tempNotes;
    
    XCTAssertEqualObjects([(ConsumerNotes *)[testShoppingItem notes] text], self.testNoteString, @"ShoppingItem failed to connect to ConsumerNotes and store text");
    
        // NOTE THAT OWNINGLIST IS NOT TESTED HERE!!!
    
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
