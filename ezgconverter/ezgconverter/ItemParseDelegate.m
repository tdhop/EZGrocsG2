//
//  ItemParseDelegate.m
//  ezgconverter
//
//  Created by Mark A Stewart on 10/29/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//

#import "ItemParseDelegate.h"
#import "SectionNames.h"
#import "CHCSVParser.h"
#import "ProductItem.h"

@interface  ItemParseDelegate()
@property BOOL shouldStoreLine; // should only store lines with numbers greater than 1
@property BOOL reuseLastRecord;   // Reuse record vs inserting new when previous item was 'UNUSED'

                    // use in switch statement to decide which product registry field to set
@property NSUInteger fieldNumber; 
@property NSUInteger recordCount;

                    // the context for the product registry database
@property (nonatomic, strong) NSManagedObjectContext *mngObjectContext;
@property (nonatomic, strong) ProductItem *currentProductRecord;
@property NSArray *sectionArray;
@end

@implementation ItemParseDelegate

- (void) setManagedObjectContext:(NSManagedObjectContext *)mngObjContext
{
    // printf ("setMngObjContext. Context=%ld.\n", (long) mngObjContext);
    self.mngObjectContext = mngObjContext;
}

                    // Implement the protocol -- note that if don't implement all of it I get crashes!
- (void) parser:(CHCSVParser *)aParser didStartDocument:(NSString *)csvFile
{
    printf("didStartDocument\n");
    
                    // Initialize state variables
    self.shouldStoreLine = NO;
    self.reuseLastRecord = NO;
    
                    // Get section list to extract section index when get section record.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SectionNames" inManagedObjectContext:self.mngObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    self.sectionArray = [self.mngObjectContext executeFetchRequest:fetchRequest error:&error];
    if (self.sectionArray == nil) {
        printf("Error retrieving Section data: %ld\n", [error code]);
    }
    for (SectionNames *sectNames in self.sectionArray)
    {
        // Debug printf("sect name=%s sect index=%ld\n",[sectNames.sectionName UTF8String],[sectNames.sectionIndex integerValue]);
    }
}

- (void) parser: (CHCSVParser *)aParser didReadField: aStringField
{
    char *argpassed = [aStringField cStringUsingEncoding:NSASCIIStringEncoding];
    // printf("The parser found a field %s\n", argpassed);
    
    if (self.shouldStoreLine)
    {
        switch (self.fieldNumber)
        {
            case ITEM_IDENTIFIER:
                // printf ("The parser found item identifier %s\n", argpassed);
                self.currentProductRecord.itemIdentifier = aStringField;
                break;
            case ITEM_NAME:
                // printf ("The parser found item name %s\n", argpassed);
                self.currentProductRecord.itemName = aStringField;
                break;
            case SECTION:
                // printf("The parser found section name %s\n", argpassed);
                self.currentProductRecord.sectionName = aStringField;
                if ([aStringField isEqualToString:@"UNUSED"])
                {
                    self.reuseLastRecord = YES;
                    // printf("Unused record found\n");
                }
                else
                {
                    self.reuseLastRecord = NO;
                }
                break;
            default:
                break;
        }
    }
                    // Set section index if got section name
    if (self.fieldNumber == SECTION)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sectionName == %@", aStringField];
        for (SectionNames *sectNameRecord in [self.sectionArray filteredArrayUsingPredicate:predicate])
        {
            self.currentProductRecord.sectionIndex = sectNameRecord.sectionIndex;
            // printf("sect index2=%ld\n",[self.currentProductRecord.sectionIndex integerValue]);
        }
    }
    self.fieldNumber++;
}

- (void) parser:(CHCSVParser *)aParser didStartLine:(NSUInteger)lineNumber
{
    // printf("didStartLine.Line#=%ld. Item=%s\n",lineNumber,[self.currentProductRecord.itemName UTF8String]);
    
    if (lineNumber > 1)
    {
        self.shouldStoreLine = YES;
        
                        // create a new record if not reusing previous
        if (self.reuseLastRecord == NO)
        {
            self.currentProductRecord = [NSEntityDescription insertNewObjectForEntityForName:@"ProductItem" inManagedObjectContext:self.mngObjectContext];
            self.recordCount++;
        }
    }
    self.fieldNumber = 0;
}

- (void) parser:(CHCSVParser *)aParser didEndLine:(NSUInteger)lineNumber
{
    // printf ("didEndLine. Read %ld fields - expected %d fields\n", self.fieldNumber, NUMFIELDS);
    
                    // Do an error check -- is fieldNumber what I expect it to be?
    if (self.fieldNumber != NUMFIELDS)
    {
        printf("Line %ld: wrong number of fields: %ld\n", lineNumber, (unsigned long)self.fieldNumber);
    }
}

- (void) parser:(CHCSVParser *)aParser didEndDocument:(NSString *)csvFile
{
    printf("Document complete. %ld records inserted\n", (unsigned long)self.recordCount);
}

- (void) parser: (CHCSVParser *)aParser didFailWithError:(NSError *)error
{
    printf ("didFailWithError\n");
}

@end
