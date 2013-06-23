//
//  Beauregard+Strategy.m
//  Bull Run
//
//  Created by Dave Townsend on 6/9/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "DPTMath.h"
#import "BAGame.h"
#import "BAMoveOrders.h"
#import "BAUnit.h"
#import "BRGame.h"
#import "Beauregard.h"
#import "Beauregard+Strategy.h"
#import "HXMMap.h"
#import "HXMPathFinder.h"
#import "HXMTerrainEffect.h"
#import "NSValue+HXMHex.h"

@implementation Beauregard (Private)

- (BOOL)unitInCorrectTheater:(BAUnit*)unit {
    HXMMap* map = [game board];

    BRAICSATheater assignedTheater = [[self unitRoles][[unit name]] integerValue];
    BRAICSATheater actualTheater = [map is:[unit location] inZone:@"manassas"]
                                   ? BRAICSATheaterEast
                                   : BRAICSATheaterWest;
    return assignedTheater == actualTheater;
}

- (int)numCsaUnitsInTheater:(BRAICSATheater)theater {
    int n = 0;

    for (NSString* name in [[self unitRoles] keyEnumerator]) {
        NSNumber* unitTheater = [self unitRoles][name];
        if ([unitTheater isEqualToNumber:@(theater)])
            n += 1;
    }

    return n;
}

- (int)numUsaUnitsInTheater:(BRAICSATheater)theater {
    __block int numSeen   = 0;
    __block int numHidden = 0;

    NSArray* usaUnits = [[game oob] unitsForSide:OtherPlayer([self side])];
    [usaUnits enumerateObjectsUsingBlock:^(BAUnit* unit, NSUInteger idx, BOOL* stop) {
        if ([unit isOffMap])
            return;

        if ([unit sighted]) {
            if ([self computeTheaterOf:unit] == theater)
                numSeen += 1;

        } else {
            numHidden += 1;
        }
    }];

    return numSeen + numHidden / 2;
}

- (int)unitDisparityIn:(BRAICSATheater)theater {
    return [self numUsaUnitsInTheater:theater] - [self numCsaUnitsInTheater:theater];
}

- (void)transferUnitTo:(BRAICSATheater)theater {
    BRAICSATheater srcTheater = OtherTheater(theater);

    __block BAUnit* bestUnit = nil;
    __block HXMHex  bestHex  = HXMHexMake(1000, -1000);

    NSArray* csaUnits = [[game oob] unitsForSide:[self side]];
    [csaUnits enumerateObjectsUsingBlock:^(BAUnit* unit, NSUInteger idx, BOOL* stop) {
        // Candidate unit must be in the source theater
        if (![[self unitRoles][[unit name]] isEqualToNumber:@(srcTheater)])
            return;

        // Candidate unit must not be on a ford
        HXMTerrainEffect* terrain = [[game board] terrainAt:[unit location]];
        if ([[terrain name] isEqualToString:@"Ford"])
            return;

        HXMHex curHex = [unit location];

        if (curHex.column < bestHex.column
            || (curHex.column == bestHex.column && curHex.row > bestHex.row)) {
            bestUnit = unit;
            bestHex = curHex;
        }
    }];

    if (bestUnit) {
        DEBUG_AI(@"Shifting %@ to theater %d", [bestUnit name], theater);
        [self unitRoles][[bestUnit name]] = @(theater);
    }
}

@end


@implementation Beauregard (Strategy)

// Routes units which are assigned to a theater but not located in that theater
- (void)conductStrategicMovement {
    //    HMMap* map = [game board];

    NSArray* csaUnits = [[game oob] unitsForSide:[self side]];
    [csaUnits enumerateObjectsUsingBlock:^(BAUnit* unit, NSUInteger idx, BOOL* stop) {
        // Don't order units twice
        if ([[self orderedThisTurn] containsObject:[unit name]])
            return;

        if (![self unitInCorrectTheater:unit]) {
            HXMHex baseHex = [self baseHexForTheater:[[self unitRoles][[unit name]] integerValue]];

            [self routeUnit:unit toDestination:baseHex];

            DEBUG_AI(@"Routing %@ to %02d%02d", [unit name], baseHex.column, baseHex.row);

            // No more orders needed for this unit
            [[self orderedThisTurn] addObject:[unit name]];
        }
    }];
}

- (BRAICSATheater)computeTheaterOf:(BAUnit*)unit {
    HXMMap* map = [game board];

    return [map is:[unit location] inZone:@"manassas"]
           ? BRAICSATheaterEast
           : BRAICSATheaterWest;
}

- (void)strategize:(BAGame *)game {
    int westThreat = [self unitDisparityIn:BRAICSATheaterWest];
    int eastThreat = [self unitDisparityIn:BRAICSATheaterEast];

    DEBUG_AI(@"Strategize: threat is %d in west vs %d in east",
             westThreat, eastThreat);

    // If there's excess in both theaters, or not enough units to cover
    // both theaters, there's not much that can be done.
    if (SIGN(westThreat) == SIGN(eastThreat))
        return;

    // Otherwise, shift units from the theater with excess to the theater
    // needing help.
    BRAICSATheater needyTheater;
    int numUnitsToTransfer;

    if (westThreat < 0) {  // west is solid, west sends units east
        needyTheater = BRAICSATheaterEast;
        numUnitsToTransfer = MIN(-westThreat, eastThreat);

    } else { // east is solid, east sends units west
        needyTheater = BRAICSATheaterWest;
        numUnitsToTransfer = MIN(-eastThreat, westThreat);
    }

    for (int i = 0; i < numUnitsToTransfer; ++i)
        [self transferUnitTo:needyTheater];
}

- (void)routeUnit:(BAUnit*)unit toDestination:(HXMHex)destination {
    HXMMap* map = [game board];
    HXMHex curHex = [unit location];

    HXMPathFinder* pf = [HXMPathFinder pathFinderOnMap:map withMinCost:4.0f];

    NSArray* path = [pf findPathFrom:curHex
                                  to:destination
                               using:^float(HXMHex from, HXMHex to) {
                                   HXMTerrainEffect* fx = [map terrainAt:to];

                                   if (!fx) // impassible
                                       return -1.0f;

                                   // TODO: ZOC/occupancy checks

                                   return [fx mpCost];
                               }];

    [[unit moveOrders] clear];

    // There's no point in planning out more than two hexes, because
    // we recalculate orders every turn and no unit moves more than
    // two hexes per turn.  Remember that the path finder returns the
    // starting hex in path[0], so the new hexes begin at path[1].
    for (int i = 1; i < 3 && i < [path count]; ++i)
        [[unit moveOrders] addHex:[path[i] hexValue]];
}

@end
