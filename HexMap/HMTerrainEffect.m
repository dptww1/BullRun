//
//  HMTerrainEffect.m
//  Bull Run
//
//  Created by Dave Townsend on 2/4/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "HMTerrainEffect.h"

@implementation HMTerrainEffect

#pragma mark - Init Method

- (id)initWithBitNum:(int)bitNum name:(NSString*)name mpCost:(float)cost {
    self = [super init];
    
    if (self) {
        _bitNum = bitNum;
        _name = name;
        _mpCost = cost;
    }
    
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeInt:   [self bitNum] forKey:@"bitNum"];
    [aCoder encodeObject:[self name]   forKey:@"name"];
    [aCoder encodeFloat: [self mpCost] forKey:@"mpCost"];
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super init];
    
    if (self) {
        _bitNum = [aDecoder decodeIntForKey:@"bitNum"];
        _name   = [aDecoder decodeObjectForKey:@"name"];
        _mpCost = [aDecoder decodeFloatForKey:@"mpCost"];
    }
    
    return self;
}

@end
