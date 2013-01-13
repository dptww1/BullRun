//
//  Terrain.m
//  Bull Run
//
//  Created by Dave Townsend on 1/12/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Terrain.h"

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
