//
//  HexMapGeometry.m
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import "HexMapGeometry.h"

@implementation HexMapGeometry

- (id)initWithLongGrain:(BOOL)longGrain firstColumnIsLong:(BOOL)firstColumnIsLong numRows:(int)rows numColumns:(int)columns {
    self = [super init];
    if (self) {
        [self setIsLongGrain:longGrain];
        [self setFirstColumnIsLong:firstColumnIsLong];
        [self setNumRows:rows];
        [self setNumColumns:columns];
    }
    return self;
}

- (BOOL)legal:(Hex)hex {
    if (hex.row < 0 || hex.column < 0)
        return NO;
    
    if (hex.column >= [self numColumns])
        return NO;
    
    // Remember that there's an extra hex in either the even or the odd columns
    int computedNumRows = [self numRows];
    
    if (((hex.column & 1) == 0) == [self firstColumnIsLong])
        computedNumRows += 1;
    
    if (hex.row >= computedNumRows)
        return NO;
    
    return YES;
}

@end
