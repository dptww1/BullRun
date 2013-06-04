//
//  HMMapZone.m
//  Bull Run
//
//  Created by Dave Townsend on 2/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "HMMapZone.h"

#define DEFAULT_BUFFER_CAPACITY  2 // this many ranges per column by default; I suspect a single range is most common

@implementation HMMapZone (Private)

- (NSMutableDictionary*)mutableDictionary {
    return (NSMutableDictionary*)[self columns];
}

@end

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
        [[self mutableDictionary] setObject:columnData forKey:colKey];
    }
    
    [(NSMutableArray*)columnData addObject:[NSValue valueWithRange:range]];
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
