//
//  ConsumerNotes+ConsumerNotesMethods.m
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "ConsumerNotes+ConsumerNotesMethods.h"

@implementation ConsumerNotes (ConsumerNotesMethods)

- (NSString *) getTruncated: (int) lengthInChars
{
    return [self.text substringToIndex: lengthInChars];
}

- (NSString *) getTruncatedWithEllipsis: (int) lengthInChars  // Will return notes truncated to lengthInChars-3 with appended "..."
{
    NSString *resultString = [self.text substringToIndex: lengthInChars - 3];
    resultString = [resultString stringByAppendingString:@"..."];
    
    return resultString;
}

@end
