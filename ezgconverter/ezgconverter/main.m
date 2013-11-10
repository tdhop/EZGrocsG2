//
//  main.m
//  ezgconverter
//
//  Created by Tim Hopmann on 8/19/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//
#import "ItemParseDelegate.h"
#import "CHCSVParser.h"
#import "SectionParseDelegate.h"
#import "SectionNames.h"

CHCSVParser *sectionParser;
CHCSVParser *itemParser;
SectionParseDelegate *sectionParserDelegate;
ItemParseDelegate *itemParserDelegate;

NSManagedObjectContext *NSMngContext;

static NSManagedObjectModel *managedObjectModel()
{
    static NSManagedObjectModel *model = nil;
    if (model != nil)
    {
        return model;
    }
                    // Get application path and append x.momd extension
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/ezgconverter.momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:path];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

static NSManagedObjectContext *managedObjectContext()
{
    static NSManagedObjectContext *context = nil;
    if (context != nil)
    {
        return context;
    }

    @autoreleasepool
    {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
#warning Fix following code so that x.sqlite output is stored in the pwd

        NSString *path = [[NSProcessInfo processInfo] arguments][0];
        path = [path stringByDeletingPathExtension];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
        
        NSError *error;
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
        
        if (newStore == nil)
        {
            printf("Store Configuration Failure %s\n", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}


int main(int argc, const char * argv[])
{
    @autoreleasepool {
                        // Create the managed object context
        NSMngContext = managedObjectContext();
        
        // Debug: NSString *applicationPath = [[NSBundle mainBundle] bundlePath];
        // Debug: printf("App path=%s\n", [applicationPath cStringUsingEncoding:NSASCIIStringEncoding]);
        // Debug: NSFileManager *fileMgr = [[NSFileManager alloc] init];
        // Debug: printf("Curr Dir Path=%s\n", [[fileMgr currentDirectoryPath] cStringUsingEncoding:NSASCIIStringEncoding]);
        
                        // Get argument vector and, if available, get path and create URL for x.csv file
        NSArray *argVector = [[NSProcessInfo processInfo] arguments];
        if (([argVector count] > 2))
        {
            if ([[argVector objectAtIndex:1] isEqualToString: @"-h"])
            {
                printf("Usage: ezgconverter <section filename.csv> <grocery item filename.csv>\n");
                printf ("Result will be placed in pwd\n");
                exit(0);
            }
            
            // Debug: const char *arg1 = [[[[NSProcessInfo processInfo] arguments] objectAtIndex:1] cStringUsingEncoding:NSASCIIStringEncoding];
            // Debug: printf("%s\n", arg1);
            
                            // Check to see if filename arguments are well formed CSV files.
            int argIndex=0;
            for (argIndex=1; argIndex < 3; argIndex++)
            {
                NSString *targetFileName = argVector[argIndex];
                if (![[targetFileName pathExtension] isEqual:@"csv"])
                {
                    printf("Usage error: File must be in CSV format\n");
                    exit(0);
                }
            }
        } else
        {
            printf("Usage: ezgconverter <section filename.csv> <grocery item filename.csv>\n");
            printf ("Result will be placed in pwd\n");
            exit(0);
        }
                        /* Get Section CSV file name, initialize parser and delegate objects, set delegate 
                           for parser, pass Managed Object Context and call parser to build section (aisle)
                           DB records.
                        */
        NSError *parsingError;
        NSString *groceryCSVFile = [[argVector[1] lastPathComponent] stringByDeletingPathExtension];
        NSURL *groceryAisleURL=[[NSBundle mainBundle] URLForResource:groceryCSVFile withExtension:@"csv"];
        printf ("URL=%s\n", [[groceryAisleURL absoluteString] cStringUsingEncoding:NSASCIIStringEncoding]);
        sectionParser = [[CHCSVParser  alloc] init];
        sectionParser = [sectionParser initWithContentsOfCSVFile:[groceryAisleURL path] encoding:NSMacOSRomanStringEncoding error:&parsingError];
        sectionParserDelegate = [[SectionParseDelegate alloc] init];
        sectionParser.parserDelegate = (id) sectionParserDelegate;
        [sectionParserDelegate setManagedObjectContext: NSMngContext];
        [sectionParser parse];
        
                        /* Get Grocery Item CSV file name and get URL in app bundle, initialize parser and 
                           delegate objects, set delegate for parser, pass Managed Object Context to 
                           delegate and call parser to build section(aisle) DB records.
                        */
        NSString *theFileName = [[argVector[2] lastPathComponent] stringByDeletingPathExtension];
        NSURL *itemDataURL = [[NSBundle mainBundle] URLForResource:theFileName withExtension:@"csv"];
        // DEBUG printf ("URL=%s\n", [[itemDataURL absoluteString] cStringUsingEncoding:NSASCIIStringEncoding]);
        itemParser = [[CHCSVParser alloc] init];
        itemParser = [itemParser initWithContentsOfCSVFile:[itemDataURL path] encoding:NSMacOSRomanStringEncoding error:&parsingError];
        itemParserDelegate = [[ItemParseDelegate  alloc] init];
        itemParser.parserDelegate = itemParserDelegate;
        [itemParserDelegate setManagedObjectContext: NSMngContext];
        [itemParser parse];
        
                        // Save managed object context
        NSError *error = nil;
        if (![NSMngContext save:&error])
        {
            printf ("Error while saving %s\n", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
    }
    exit (0);
}