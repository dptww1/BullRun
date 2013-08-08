//
//  McDowell+Tactics.m
//  Bull Run
//
//  Created by Dave Townsend on 5/25/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BR1Map.h"
#import "HexMap.h"
#import "McDowell.h"
#import "McDowell+Strategy.h"
#import "McDowell+Tactics.h"
#import "NSArray+DPTUtil.h"


@implementation McDowell (Private)

- (HXMHex)closestCsaBaseTo:(HXMHex)hex {
    BR1Map*        map     = [BR1Map map];
    __block HXMHex minHex  = HXMHexMake(-1, -1);
    __block int    minDist = INT_MAX;

    NSArray* bases = [map basesForSide:OtherPlayer([self side])];
    [bases
     enumerateObjectsUsingBlock:^(NSValue* val, NSUInteger idx, BOOL* stop) {
         HXMHex curHex  = [val hexValue];
         int    curDist = [map distanceFrom:hex to:curHex];
         if (curDist < minDist) {
             minDist = curDist;
             minHex  = curHex;
         }
     }];

    return minHex;
}

- (void)devalueInfluenceMap:(BATAIInfluenceMap*)imap atHex:(HXMHex)hex {
    HXMMap* map = [game board];

    [imap multiplyBy:0.25f atHex:hex];

    for (int dir = 0; dir < 6; ++dir)
        [imap multiplyBy:0.5f atHex:[map hexAdjacentTo:hex inDirection:dir]];
}

// Find combat-worthy unit having matching role, possibly nil
// "Combat-Worthy" means 1) on-map, 2) not wrecked, 3) not already assigned
// returned unit will be marked as ordered for this turn
- (BATUnit*)findCombatWorthyUnitWithRole:(BRAIUSAUnitRole)requiredRole {
    NSArray* usaUnits = [[game oob] unitsForSide:[self side]];
    return [usaUnits dpt_find:^BOOL(BATUnit* unit) {
        if ([[self orderedThisTurn] containsObject:[unit name]])
            return NO;

        if ([unit isOffMap])
            return NO;

        if ([unit isWrecked])
            return NO;

        NSNumber* role = [[self unitRoles] valueForKey:[unit name]];
        BOOL ok = [role isEqualToNumber:[NSNumber numberWithInt:requiredRole]];

        if (ok)
            [[self orderedThisTurn] addObject:[unit name]];

        return ok;
    }];
}

// TODO: Really needs to use A* algorithm, and respect things like not trying to
// move unit through ZOC.
- (void)routeUnit:(BATUnit*)unit toDestination:(HXMHex)destination {
    [[unit moveOrders] clear];

    HXMMap* map = [game board];
    HXMHex curHex = [unit location];

    // There's no point in planning out more than two hexes, because
    // we recalculate orders every turn and no unit moves more than
    // two hexes per turn.
    for (int i = 0; i < 2 && !HXMHexEquals(curHex, destination); ++i) {
        int dir = [map directionFrom:curHex to:destination];
        HXMHex nextHex = [map hexAdjacentTo:curHex inDirection:dir];

        [[unit moveOrders] addHex:nextHex];

        curHex = nextHex;
    }
}

@end

@implementation McDowell (Tactics)

- (BOOL)assignAttacker {
    HXMMap* map = [game board];

    BATUnit* u = [self findCombatWorthyUnitWithRole:BRAIUSAUnitRoleAttack];
    if (!u)
        return NO;

    // If in CSA zone, move to nearest base
    if ([map is:[u location] inZone:@"csa"]) {
        [self routeUnit:u toDestination:[self closestCsaBaseTo:[u location]]];

    } else { // else north of river -- move to attack ford
        [self routeUnit:u toDestination:[self attackFord]];
    }

    return YES;
}

- (BOOL)assignDefender:(BATAIInfluenceMap*)imap {
    HXMHexAndDistance hexd = [imap largestValue];
    if (hexd.distance < 1)
        return NO;

    __block BATUnit* bestUnit     = nil;
    __block int      bestDistance = 1000;

    NSArray* usaUnits = [[game oob] unitsForSide:[self side]];
    [usaUnits enumerateObjectsUsingBlock:^(BATUnit* unit, NSUInteger idx, BOOL* stop) {
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
    HXMMap* map = [game board];

    BATUnit* u = [self findCombatWorthyUnitWithRole:BRAIUSAUnitRoleFlank];
    if (!u)
        return NO;

    // If in CSA zone or a ford, move to nearest base
    if ([map is:[u location] inZone:@"csa"]) {
        HXMHex closestBase = [self closestCsaBaseTo:[u location]];
        DEBUG_AI(@"Assigning Flanker %@ to base %02d%02d", [u name], closestBase.column, closestBase.row);
        [self routeUnit:u toDestination:closestBase];

    } else { // else north of river -- move to attack ford
        DEBUG_AI(@"Assigning Flanker %@ to ford %02d%02d", [u name], [self flankFord].column, [self flankFord].row);
        [self routeUnit:u toDestination:[self flankFord]];
    }

    return YES;
}

- (BOOL)reRoute {  // TODO: might not need this if we make assignXXX methods smarter
    return NO;
}

@end
