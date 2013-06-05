//
//  HMMapZone.m
//  Bull Run
//
//  Created by Dave Townsend on 2/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "HMMapZone.h"

// # default ranges per column I suspect a single range is most common case
static const int DEFAULT_BUFFER_CAPACITY = 2;


//==============================================================================
@interface HMMapZone ()

// Keys:Column Numbers (as NSNumber)  Values: NSArray of NSRanges
@property (nonatomic,strong) NSMutableDictionary* columns;

@end


//==============================================================================
@implementation HMMapZone

#pragma mark - Initialization

- (id)init {
    self = [super init];
    
    if (self) {
        _columns = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - Behaviors

- (BOOL)containsHex:(HMHex)hex {
    NSNumber* colKey = [NSNumber numberWithInt:hex.column];
    NSArray* columnData = [self.columns objectForKey:colKey];
    
    if (!columnData)
        return NO;
    
    for (NSValue* v in columnData) {
        if (NSLocationInRange(hex.row, [v rangeValue]))
            return YES;
    }
    
    return NO;
}

#pragma mark - Population Methods

- (void)addRange:(NSRange)range forColumn:(int)column {
    NSNumber* colKey = [NSNumber numberWithInt:column];
    NSMutableArray* columnData = [self.columns objectForKey:colKey];
    
    if (!columnData) {
        columnData = [NSMutableArray array];
        [_columns setObject:columnData forKey:colKey];
    }
    
    [columnData addObject:[NSValue valueWithRange:range]];
}


#pragma mark - NSCoding Implementation

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.columns = [aDecoder decodeObjectForKey:@"columnData"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self columns] forKey:@"columnData"];
}

@end
