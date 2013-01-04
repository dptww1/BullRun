//
//  HexMapCoordinateTransformer.m
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import "HexMapCoordinateTransformer.h"
#import "HexMapGeometry.h"


@implementation HexMapCoordinateTransformer (Private)

- (CGPoint)offsetFromOrigin:(CGPoint)p {
    return CGPointMake(p.x - [self origin].x, p.y - [self origin].y);
}

@end

@implementation HexMapCoordinateTransformer

- (id)initWithGeometry:(HexMapGeometry *)geometry origin:(CGPoint)origin hexSize:(CGSize)hexSize {
    self = [super init];
    if (self) {
        [self setGeometry:geometry];
        [self setOrigin:origin];
        [self setHexSize:hexSize];
    }
    return self;
}

- (CGPoint)hexToScreen:(Hex)hex {
    return CGPointMake(0.0, 0.0);
}

- (Hex)screenToHex:(CGPoint)point {
    CGPoint p = [self offsetFromOrigin:point];
    
    // Hardwired for Bull Run's geometry for now.... :^(
    
    int col = p.x / [self hexSize].width;
    
    // The second, fourth, etc. columns are skewed by half a hex relative to their first, third, fifth, etc.
    // column siblings.  So we have to offset the passed-in y-coordinate accordingly to find the corresponding hex.
    if (col & 1) {
        int halfHexOffset = [self hexSize].height / 2.0;
        
        if ([[self geometry] firstColumnIsLong]) // then the second column is short
            p.y -= halfHexOffset;
        
        else // the first column is short
            p.y += halfHexOffset;
    }
    
    if (p.x < 0.0 || p.y < 0.0)
        return HexMake(-1, -1);
    
    int row = p.y / [self hexSize].height;
    
    Hex h = HexMake(col, row);
    return [[self geometry] legal:h] ? h : HexMake(-1, -1);
}

@end
