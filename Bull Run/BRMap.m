//
//  BRMap.m
//  Bull Run
//
//  Created by Dave Townsend on 5/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAGame.h"
#import "BRMap.h"

@implementation BRMap

+ (BRMap*)map {
    return (BRMap*)[game board];
}

- (BOOL)isCsa:(HMHex)hex {
    return [self is:hex inZone:@"csa"];
}

- (BOOL)isUsa:(HMHex)hex {
    return [self is:hex inZone:@"usa"];
}

- (BOOL)isEnemy:(HMHex)hex of:(PlayerSide)side { // TODO: generalize?
    return (side == CSA && [self isUsa:hex])
        || (side == USA && [self isCsa:hex]);
}

- (HMHexAndDistance)closestFordTo:(HMHex)hex {
    __block HMHexAndDistance hexd;
    hexd.hex = HMHexMake(-1, -1);
    hexd.distance = 1000;

    NSArray* fords = [self findHexesOfType:@"Ford"];

    [fords enumerateObjectsUsingBlock:^(NSValue* obj, NSUInteger idx, BOOL* stop) {
         HMHex fordHex;
         [obj getValue:&fordHex];

         int dist = [self distanceFrom:hex to:fordHex];

         if (dist < hexd.distance) {
             hexd.hex = fordHex;
             hexd.distance = dist;
         }
     }];

    return hexd;
}

- (NSArray*)basesForSide:(PlayerSide)side {
    NSMutableArray* bases = [NSMutableArray arrayWithCapacity:5];

    NSArray* towns = [self findHexesOfType:@"Town"];
    [towns enumerateObjectsUsingBlock:^(NSValue* obj, NSUInteger idx, BOOL* stop) {
        HMHex townHex;
        [obj getValue:&townHex];

        if (![self isEnemy:townHex of:side])
            [bases addObject:[NSValue value:&townHex withObjCType:@encode(HMHex)]];
     }];

    return bases;
}

@end
