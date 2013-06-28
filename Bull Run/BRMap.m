//
//  BRMap.m
//  Bull Run
//
//  Created by Dave Townsend on 5/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATGame.h"
#import "BRMap.h"
#import "NSValue+HXMHex.h"

@implementation BRMap

+ (BRMap*)map {
    return (BRMap*)[game board];
}

- (BOOL)isCsa:(HXMHex)hex {
    return [self is:hex inZone:@"csa"];
}

- (BOOL)isUsa:(HXMHex)hex {
    return [self is:hex inZone:@"usa"];
}

- (BOOL)isEnemy:(HXMHex)hex of:(PlayerSide)side { // TODO: generalize?
    return (side == CSA && [self isUsa:hex])
        || (side == USA && [self isCsa:hex]);
}

- (HXMHexAndDistance)closestFordTo:(HXMHex)hex {
    __block HXMHexAndDistance hexd;
    hexd.hex = HXMHexMake(-1, -1);
    hexd.distance = 1000;

    NSArray* fords = [self findHexesOfType:@"Ford"];

    [fords enumerateObjectsUsingBlock:^(NSValue* obj, NSUInteger idx, BOOL* stop) {
         HXMHex fordHex;
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
        HXMHex townHex;
        [obj getValue:&townHex];

        if (![self isEnemy:townHex of:side])
            [bases addObject:[NSValue valueWithHex:townHex]];
     }];

    return bases;
}

@end
