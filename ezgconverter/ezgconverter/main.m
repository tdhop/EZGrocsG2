//
//  main.m
//  ezgconverter
//
//  Created by Tim Hopmann on 8/19/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//

static NSManagedObjectModel *managedObjectModel()
{
    static NSManagedObjectModel *model = nil;
    if (model != nil) {
        return model;
    }
    
    // Get application path and append x.momd extension
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/ezgconverter.momd"];
    // DEBUG: printf("%s\n", [path cStringUsingEncoding:NSASCIIStringEncoding]);
    // Form URL
    NSURL *modelURL = [NSURL fileURLWithPath:path];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

static NSManagedObjectContext *managedObjectContext()
{
    static NSManagedObjectContext *context = nil;
    if (context != nil) {
        return context;
    }

    @autoreleasepool {
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
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        // Create the managed object context
        NSManagedObjectContext *context = managedObjectContext();
        
        // ALL CUSTOM CODE SHOULD GO HERE
        
        // Get application path
        NSString *applicationPath = [[NSBundle mainBundle] bundlePath];
        printf("%s\n", [applicationPath cStringUsingEncoding:NSASCIIStringEncoding]);
        
        // Get present working directory - will use to form URL for target file and to
        NSFileManager *fileMgr = [[NSFileManager alloc] init];
        NSString *presentWorkingDirectory = [fileMgr currentDirectoryPath];
        // DEBUG: printf("%s\n", [presentWorkingDirectory cStringUsingEncoding:NSASCIIStringEncoding]);
        
        // Get argument vector and, if available, get path and create URL for x.csv file
        NSArray *argVector = [[NSProcessInfo processInfo] arguments];
        if (([argVector count] > 1)) {
            if ([[argVector objectAtIndex:1] isEqualToString: @"-h"]) {
                printf("Usage: ezgconverter <target filename.csv>\nResult will be placed in pwd\n");
                exit(0);
            }
#warning Test code - to be removed
            printf("I got here\n");
            const char *arg1 = [[[[NSProcessInfo processInfo] arguments] objectAtIndex:1] cStringUsingEncoding:NSASCIIStringEncoding];
            printf("%s\n", arg1);
            
            // Check to see if [argVector][1] is well formed
            NSString *targetFileName = argVector[1]; // Note the new array_ptr[index] syntax for accessing contents of NSArray
            if (![[targetFileName pathExtension] isEqual:@"csv"]) {
                printf("Usage error: File must be in CSV format");
                exit(0);
            }
            
        } else {
            printf("Usage: ezgconverter <target filename.csv>\nResult will be placed in pwd\n");
            exit(0);
        }
        
        // END OF CUSTOM CODE
        
        
        
        // Save the managed object context
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
    }
    return 0;
}

