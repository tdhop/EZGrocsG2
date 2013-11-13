//
//  SectionParseDelegate.m
//  ezgconverter
//
//  Created by Mark A Stewart on 11/4/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//

#import "SectionParseDelegate.h"
#import "ProductItem.h"
#import "SectionNames.h"
#import "CHCSVParser.h"

@interface SectionParseDelegate ()

- (void) setManagedObjectContext:(NSManagedObjectContext *) mngObjContext;

@property (nonatomic, strong) NSManagedObjectContext *mngObjectContext; // Mng Obj Context for DB.
@property (nonatomic, strong) SectionNames *sectionRecord;
@property NSUInteger recordCount;
@end

@implementation SectionParseDelegate

- (void) setManagedObjectContext:(NSManagedObjectContext *)mngObjContext
{
    // printf ("setMngObjContext. Context=%ld.\n", (long) mngObjContext);
    self.mngObjectContext = mngObjContext;
}

                    // Implement the protocol -- note that if I don't implement all of it I get crashes!
                    // Here's the delegate method that will give me fields.

- (void) parser: (CHCSVParser *)aParser didReadField: aStringField
{
    // printf("The parser found a section field %s\n", [aStringField UTF8String]);
    
    self.sectionRecord.sectionName = aStringField;
    self.sectionRecord.sectionIndex = [NSNumber numberWithInt:self.recordCount];
}

- (void) parser:(CHCSVParser *)aParser didStartDocument:(NSString *)csvFile
{
    printf("didStartDocument: Grocery Aisle\n");
}

- (void) parser:(CHCSVParser *)aParser didStartLine:(NSUInteger)lineNumber
{
    // printf("didStartLine: Grocery Aisle\n");
    
    self.sectionRecord = [NSEntityDescription insertNewObjectForEntityForName:@"SectionNames" inManagedObjectContext:self.mngObjectContext];
    self.recordCount++;
}

- (void) parser:(CHCSVParser *)aParser didEndLine:(NSUInteger)lineNumber
{
   // printf ("didEndLine: Grocery Aisles, no further action\n");
}

- (void) parser:(CHCSVParser *)aParser didEndDocument:(NSString *)csvFile
{
    printf("didEndDocument: Grocery Aisles\n");
    printf("Document successfully saved. %ld records saved\n", self.recordCount);
}

- (void) parser: (CHCSVParser *)aParser didFailWithError:(NSError *)error
{
    printf("didFailWithError: Grocery Aisles\n");
}

@end
