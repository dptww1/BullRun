//
//  MapZone.m
//  Bull Run
//
//  Created by Dave Townsend on 2/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "MapZone.h"
#import "ResizableBuffer.h"

#define DEFAULT_BUFFER_CAPACITY  2 // this many ranges per column by default; I suspect a single range is most common

@implementation MapZone (Private)

- (NSMutableDictionary*)mutableDictionary {
    return (NSMutableDictionary*)[self columnData];
}

@end

@implementation MapZone

#pragma mark - Initialization

- (id)init {
    self = [super init];
    
    if (self) {
        _columnData = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark - Behaviors

- (BOOL)containsHex:(Hex)hex {
    NSNumber* column = [NSNumber numberWithInt:hex.column];
    ResizableBuffer* ranges = [self.columnData objectForKey:column];
    if (!ranges)
        return NO;
    
    for (int i = 0; i < [ranges count]; ++i) {
        NSRange rng = *(NSRange*)[ranges getObjectAt:i];
        if (NSLocationInRange(hex.row, rng))
            return YES;
    }
    
    return NO;
}

#pragma mark - Population Methods

- (void)addRange:(NSRange)range forColumn:(int)column {
    NSNumber* colKey = [NSNumber numberWithInt:column];
    ResizableBuffer* thisCol = [[self columnData] objectForKey:colKey];
    
    if (!thisCol) {
        thisCol = [ResizableBuffer bufferWithCapacity:DEFAULT_BUFFER_CAPACITY ofObjectSize:sizeof(NSRange)];
        [[self mutableDictionary] setObject:thisCol forKey:colKey];
    }
    
    [thisCol add:&range];
}


#pragma mark - NSCoding Implementation

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.columnData = [aDecoder decodeObjectForKey:@"columnData"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self columnData] forKey:@"columnData"];
}

@end
