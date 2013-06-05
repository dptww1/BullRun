//
//  HMCoordinateTransformer.m
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import "HMCoordinateTransformer.h"
#import "HMGeometry.h"


//==============================================================================
@implementation HMCoordinateTransformer (Private)

- (CGPoint)offsetFromOrigin:(CGPoint)p {
    return CGPointMake(p.x - [self origin].x, p.y - [self origin].y);
}

@end


//==============================================================================
@implementation HMCoordinateTransformer

- (id)initWithMap:(HMMap*)map origin:(CGPoint)origin hexSize:(CGSize)hexSize {
    self = [super init];
    if (self) {
        _map     = map;
        _origin  = origin;
        _hexSize = hexSize;
    }
    return self;
}

- (CGPoint)hexCenterToScreen:(HMHex)h {
    CGPoint pt = [self hexToScreen:h];
    pt.x += _hexSize.width  / 2;
    pt.y += _hexSize.height / 2;
    return pt;
}

- (CGPoint)hexToScreen:(HMHex)hex {
    float x = _origin.x;
    float y = _origin.y;
    
    x += hex.column * _hexSize.width;
    y += hex.row * _hexSize.height;
    
    if (hex.column & 1) {
        y -= (_hexSize.height / 2.0);
    }
    
    return CGPointMake(x, y);
}

- (HMHex)screenToHex:(CGPoint)point {
    CGPoint p = [self offsetFromOrigin:point];
    
    int col = p.x / _hexSize.width;
    
    // The second, fourth, etc. columns are skewed by half a hex relative to their first, third, fifth, etc.
    // column siblings.  So we have to offset the passed-in y-coordinate accordingly to find the corresponding hex.
    if (col & 1) {
        int halfHexOffset = _hexSize.height / 2.0;
        
        if ([[_map geometry] firstColumnIsLong]) // then the second column is short
            p.y -= halfHexOffset;
        
        else // the first column is short
            p.y += halfHexOffset;
    }
    
    if (p.x < 0.0 || p.y < 0.0)
        return HMHexMake(-1, -1);
    
    int row = p.y / [self hexSize].height;
    
    HMHex h = HMHexMake(col, row);
    return [_map legal:h] ? h : HMHexMake(-1, -1);
}

@end
