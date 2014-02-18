//
//  DataClassesTest.m
//  EZGrocs
//
//  Created by Tim Hopmann on 2/8/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProductItem.h"
#import "ConsumerNotes.h"
#import "StoreSection.h"
#import "ShoppingItem.h"
#import "ShoppingItemList.h"
#import "ListPortfolio.h"

@interface DataClassesTest : XCTestCase

@property NSManagedObjectContext *testMOC;
@property NSNumber *testInteger;
@property NSNumber *testBool;

@end

@implementation DataClassesTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle mainBundle]]];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    XCTAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    self.testMOC = [[NSManagedObjectContext alloc] init];
    self.testMOC.persistentStoreCoordinator = psc;
    
        //Set up numbers for test
    self.testInteger = [NSNumber numberWithInt:5];
    self.testBool = [NSNumber numberWithBool:YES];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (id) createInstanceOfEntity: (NSString *) entityName
{
    id newItem = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.testMOC];
    
    return newItem;
}

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
    XCTAssertEqual(testSection.sectionSequenceID, self.testInteger, @"StoreSection failed to store sectionSequenceID");

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
    
    
        //Test fetched properties
    NSArray * sections =[testProduct valueForKey:@"sectionInfo"];
    XCTAssert([sections count] == 1, @"Product Item did not return proper number of StoreSections from fetched property sectionInfo");
    
    StoreSection *sectionForTestProduct = [sections lastObject];
    XCTAssertNotNil(sectionForTestProduct, @"ProductItem failed to return fetched property 'sectionInfo'");
    
    
}


@end
