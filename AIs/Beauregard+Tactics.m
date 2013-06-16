//
//  Beauregard+Tactics.m
//  Bull Run
//
//  Created by Dave Townsend on 6/16/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAAIInfluenceMap.h"
#import "BAGame.h"
#import "BAUnit.h"
#import "Beauregard+Strategy.h"
#import "Beauregard+Tactics.h"

//==============================================================================
@implementation Beauregard (Private)

- (void)devalueInfluenceMap:(BAAIInfluenceMap*)imap atHex:(HMHex)hex {
    HMMap* map = [game board];

    [imap multiplyBy:0.25f atHex:hex];

    for (int dir = 0; dir < 6; ++dir)
        [imap multiplyBy:0.5f atHex:[map hexAdjacentTo:hex inDirection:dir]];
}

@end


//==============================================================================
@implementation Beauregard (Tactics)

- (BOOL)assignAttacker {
    return NO;
}

- (BOOL)assignDefender:(BAAIInfluenceMap*)imap {
    HMMap* map = [game board];
    HMHexAndDistance hexd = [imap largestValue];
    if (hexd.distance < 1)
        return NO;

    __block BAUnit* bestUnit     = nil;
    __block int     bestDistance = 1000;

    NSArray* csaUnits = [[game oob] unitsForSide:[self side]];
    [csaUnits enumerateObjectsUsingBlock:^(BAUnit* unit, NSUInteger idx, BOOL* stop) {
        if ([[self orderedThisTurn] containsObject:[unit name]])
            return;

        int curDistance = [map distanceFrom:[unit location] to:hexd.hex];
        if (curDistance < bestDistance) {
            bestUnit     = unit;
            bestDistance = curDistance;
        }
    }];

    if (bestUnit) {
        DEBUG_AI(@"assignDefender %@ to %02d%02d", [bestUnit name], hexd.hex.column, hexd.hex.row);
        [self routeUnit:bestUnit toDestination:hexd.hex];
        [[self orderedThisTurn] addObject:[bestUnit name]];
        [self devalueInfluenceMap:imap atHex:hexd.hex];
    } else
        DEBUG_AI(@"assignDefender fails because no defenders are left");

    return bestUnit != nil;
}
@end
