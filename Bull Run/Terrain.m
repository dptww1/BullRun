//
//  Terrain.m
//  Bull Run
//
//  Created by Dave Townsend on 1/12/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Terrain.h"

// Bit 0 =  1 => CSA
// Bit 1 =  2 => USA
// Bit 2 =  4 => Cub Run
// Bit 3 =  8 => Woods
// Bit 4 = 16 => Ford
// Bit 5 = 32 => Town


@implementation Terrain {
    int _val;
}

- (id)initWithInt:(int)rawValue {
    self = [super init];
    
    if (self) {
        _val = rawValue;
    }
    
    return self;
}

- (BOOL)isCsa {
    return _val & 1 ? YES : NO;
}

- (BOOL)isUsa {
    return _val & 2 ? YES : NO;
}

- (BOOL)isEnemy:(PlayerSide)side {
    return side == USA ? [self isUsa] : [self isCsa];
}

- (BOOL)onSameSideOfRiver:(Terrain *)otherTerrain {
    return ([self isCsa] && [otherTerrain isCsa])
        || ([self isUsa] && [otherTerrain isUsa]);
}

@end
