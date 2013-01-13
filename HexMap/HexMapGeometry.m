//
//  HexMapGeometry.m
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import "HexMapGeometry.h"

@implementation HexMapGeometry

#pragma mark - Initialization

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

#pragma mark - Private Utilities

- (BOOL)columnIsLong:(int)column {
    return ((column & 1) == 0) == [self firstColumnIsLong];
}

#pragma mark - Behaviors

- (BOOL)legal:(Hex)hex {
    if (hex.row < 0 || hex.column < 0)
        return NO;
    
    if (hex.column >= [self numColumns])
        return NO;
    
    // Remember that there's an extra hex in either the even or the odd columns
    int computedNumRows = [self numRows];
    
    if ([self columnIsLong:hex.column])
        computedNumRows += 1;
    
    if (hex.row >= computedNumRows)
        return NO;
    
    return YES;
}

- (int)distanceFrom:(Hex)from to:(Hex)to {
    if (![self legal:from] || ![self legal:to])
        return -1;
    
    // Distance is reciprocal, so despite the parameter names it doesn't really matter
    // which hex is the "from" hex and which hex is the "to".  However, it makes our
    // calculations here a little easier if the "from" hex is to the left of the "to"
    // hex.  So swap them if need be.
    if (to.column < from.column) {
        Hex tmp = HexMake(from.column, from.row);
        from = to;
        to = tmp;
    }
    
    int dx, dy;
    
    dx = abs(from.column - to.column); // abs not strictly needed, because we know from.col <= to.col....
    dy = abs(from.row    - to.row);
    
    // The dy might be misleading if we are going from a long column to a non-long column.
    // For example, (0,0) and (1,1) are actually adjacent if column 0 is short.
    BOOL fromIsLong = [self columnIsLong:from.column];
    BOOL toIsLong   = [self columnIsLong:to.column];
    
    // Account for potential off-by-one errors when chcking between long and short columns
    if (fromIsLong != toIsLong) {
        if (fromIsLong) {
            if (from.row > to.row)
                dy -= 1;
            
        } else { // toIsLong
            if (to.row > from.row)
                dy -= 1;
        }
    }
    
    // The distance is always at least the distance between the columns, so dx is
    // always a component in the calculation, because you always have to go at least
    // that many hexes.  But the dy component is not so straightforward, because every
    // two hexes of movement from column to column can get you closer to the destination
    // row by 1 or 2 hexes (depending on the exact grain configuration.
    dy -= dx / 2;

    // dy can go negative, which just means it's overwhelmed by the dx component; that's
    // fine, but we have to reset dy to 0 so the addition in the return statement works.
    if (dy < 0)
        dy = 0;

    return dx + dy;
}

#pragma mark - NSCoding Implementation

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:_isLongGrain       forKey:@"isLongGrain"];
    [aCoder encodeBool:_firstColumnIsLong forKey:@"firstColumnIsLong"];
    [aCoder encodeInt:_numRows            forKey:@"numRows"];
    [aCoder encodeInt:_numColumns         forKey:@"numColumns"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _isLongGrain       = [aDecoder decodeIntForKey:@"isLongGrain"];
        _firstColumnIsLong = [aDecoder decodeIntForKey:@"firstColumnIsLong"];
        _numRows           = [aDecoder decodeIntForKey:@"numRows"];
        _numColumns        = [aDecoder decodeIntForKey:@"numColumns"];
    }
    
    return self;
}

@end
