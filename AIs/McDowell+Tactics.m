//
//  McDowell+Tactics.m
//  Bull Run
//
//  Created by Dave Townsend on 5/25/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAAIInfluenceMap.h"
#import "BAGame.h"
#import "BAMoveOrders.h"
#import "BAUnit.h"
#import "HMHex.h"
#import "McDowell.h"
#import "McDowell+Strategy.h"
#import "McDowell+Tactics.h"

@implementation McDowell (Private)

- (void)devalueInfluenceMap:(BAAIInfluenceMap*)imap atHex:(HMHex)hex {
    HMMap* map = [game board];

    [imap divideBy:4.0f atHex:hex];

    for (int dir = 0; dir < 6; ++dir)
        [imap divideBy:2.0f atHex:[map hexAdjacentTo:hex inDirection:dir]];
}

// TODO: Really needs to use A* algorithm, and respect things like not trying to
// move unit through ZOC.
- (void)routeUnit:(BAUnit*)unit toDestination:(HMHex)destination {
    [[unit moveOrders] clear];

    HMMap* map = [game board];
    HMHex curHex = [unit location];

    // There's no point in planning out more than two hexes, because
    // we recalculate orders every turn and no unit moves more than
    // two hexes per turn.
    for (int i = 0; i < 2 && !HMHexEquals(curHex, destination); ++i) {
        int dir = [map directionFrom:curHex to:destination];
        HMHex nextHex = [map hexAdjacentTo:curHex inDirection:dir];

        [[unit moveOrders] addHex:nextHex];

        curHex = nextHex;
    }
}

@end

@implementation McDowell (Tactics)

- (BOOL)assignAttacker {
    // Find USA unit marked as attacker, not shattered, not offmap

    // If in CSA zone, move to nearest base

    // else north of river -- move to attack ford

    return NO;
}

- (BOOL)assignDefender:(BAAIInfluenceMap*)imap {
    HMHexAndDistance hexd = [imap largestValue];
    if (hexd.distance < 1)
        return NO;

    __block BAUnit* bestUnit     = nil;
    __block int     bestDistance = 1000;

    NSArray* usaUnits = [[game oob] unitsForSide:[self side]];
    [usaUnits enumerateObjectsUsingBlock:^(BAUnit* unit, NSUInteger idx, BOOL* stop) {
        if (![self isUsaUnitDefending](unit))
            return;

        if ([[self orderedThisTurn] containsObject:[unit name]])
            return;

        int curDistance = [[game board] distanceFrom:[unit location] to:hexd.hex];
        if (curDistance < bestDistance) {
            bestUnit     = unit;
            bestDistance = curDistance;

        } else if (curDistance == bestDistance) {  // TODO: compare ZOC problem status
            bestUnit     = unit;
            bestDistance = curDistance;
        }
    }];

    if (bestUnit) {
        DEBUG_AI(@"Assigning Defender %@ to %02d%02d", [bestUnit name], hexd.hex.column, hexd.hex.row);
        [self routeUnit:bestUnit toDestination:hexd.hex];
        [[self orderedThisTurn] addObject:[bestUnit name]];
        [self devalueInfluenceMap:imap atHex:hexd.hex];
    } else
        DEBUG_AI(@"Assigning Defender fails because no defenders are left");

    return bestUnit != nil;
}

- (BOOL)assignFlanker {
    // Find USA unit marked as attacker, not shattered, not offmap

    // If in CSA zone, move to nearest base

    // else north of river -- move to flank ford

    return NO;
}

- (BOOL)reRoute {  // TODO: might not need this if we make assignXXX methods smarter
    return NO;
}

@end
