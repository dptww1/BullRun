//
//  HexMapCoordinateTransformer.m
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import "HexMapCoordinateTransformer.h"
#import "HexMapGeometry.h"

Hex HexMake(int col, int row) {
    return (Hex){ col, row };
}

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
    return HexMake(0, 0);
}

@end
