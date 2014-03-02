//
//  ConsumerNotes+ConsumerNotesMethods.h
//  EZGrocs
//
//  Created by Tim Hopmann on 3/2/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "ConsumerNotes.h"
#define AUTO_TRUNCATE_CHARS 100

@interface ConsumerNotes (ConsumerNotesMethods)

- (NSString *) getTruncated: (int) lengthInChars;

- (NSString *) getTruncatedWithEllipsis: (int) lengthInChars; // Will return notes truncated to lengthInChars-3 with appended "..."

@end
