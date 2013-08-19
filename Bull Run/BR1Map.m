//
//  BR1Map.m
//  Bull Run
//
//  Created by Dave Townsend on 5/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATGame.h"
#import "BR1Map.h"

@implementation BR1Map

+ (BR1Map*)map {
    return (BR1Map*)[game board];
}

- (BOOL)isHex:(HXMHex)hex enemyOfPlayer:(PlayerSide)side {
    return (side == CSA && [self is:hex inZone:@"usa"])
        || (side == USA && [self is:hex inZone:@"csa"]);
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

        if (![self isHex:townHex enemyOfPlayer:side])
            [bases addObject:[NSValue valueWithHex:townHex]];
     }];

    return bases;
}

@end
