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

- (int)directionFrom:(Hex)from to:(Hex)to {
    // Fractions.  You're going to get fractions.  So use floats rather than ints.
    double fromRow = from.row;
    double fromCol = from.column;
    double toRow   = to.row;
    double toCol   = to.column;
    
    // Offset odd columns
    if ((from.column & 1) && !_firstColumnIsLong)
        fromRow -= 0.5;
    
    if ((to.column & 1) && !_firstColumnIsLong)
        toRow -= 0.5;
    
    // The center of each hex side is at a 60 degree angle from its neighbors.
    // So the hex spines between directions (0,5), (0,1), (3,4), and (3,2) are at
    // 30-degree angles from the center.  So if the "to" hex is within 30 degrees
    // of the y-axis centered on the "from" hex, we want to return a vertical direction
    // (either 0 or 3 as appropriate).  The easiest way to check this seems to be
    // by comparing our deltas to a 30-60-90 triangle, which have sides in the given
    // proportions:
    //
    //           1
    //         -----
    //         |   /
    // sqrt(3) |  / 2
    //         | /
    //         |/
    //
    // The dx value gives us the 1 side. The dy value gives us the sqrt(3) side, but
    // we have to scale by sqrt(3) because of the geometry of the hexes so that the
    // units are equivalent.  Side 2 is then just the distance between the two points.

    float dx = toCol - fromCol;
    float dy = (toRow - fromRow) * sqrt(3.0);
    
    float dist = sqrt(dx * dx + dy * dy);
    
    // First figure out whether we're going uppish or downish
    if (dy <= 0) { // then we're going up, more or less
        
        if (dist >= 2 * abs(dx))
            return 0;
        
        return dx < 0 ? 5 : 1;
        
    } else { // we're going down, more or less
        
        if (dist >= 2 * abs(dx))
            return 3;
        
        return dx < 0 ? 4 : 2;
    }
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

- (int)numCells {
    return (_numRows + 1) * _numColumns;
}

- (int)rotateDirection:(int)dir clockwise:(BOOL)cw {
    return [self normalizeDirection:[self normalizeDirection:dir] + (cw ? 1 : -1)];
}

- (int)normalizeDirection:(int)dir {
    if (0 <= dir && dir <= 5)
        return dir;

    while (dir < 0)
        dir += 6;
    
    return dir % 6;
}

- (Hex)hexAdjacentTo:(Hex)start inDirection:(int)dir {
    Hex newHex = start;
    
    switch ([self normalizeDirection:dir]) {
    case 0:
        newHex.row -= 1;
        break;
    
    case 1:
        newHex.row -= [self columnIsLong:start.column] ? 1 : 0;
        newHex.column += 1;
        break;
            
    case 2:
        newHex.row += [self columnIsLong:start.column] ? 0 : 1;
        newHex.column += 1;
        break;
    
    case 3:
        newHex.row += 1;
        break;
            
    case 4:
        newHex.row += [self columnIsLong:start.column] ? 0 : 1;
        newHex.column -= 1;
        break;
            
    
    case 5:
        newHex.row -= [self columnIsLong:start.column] ? 1 : 0;
        newHex.column -= 1;
        break;
    }
    
    return newHex;
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
        _isLongGrain       = [aDecoder decodeBoolForKey:@"isLongGrain"];
        _firstColumnIsLong = [aDecoder decodeBoolForKey:@"firstColumnIsLong"];
        _numRows           = [aDecoder decodeIntForKey:@"numRows"];
        _numColumns        = [aDecoder decodeIntForKey:@"numColumns"];
    }
    
    return self;
}

@end
