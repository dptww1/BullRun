//
//  McDowell+Strategy.m
//  Bull Run
//
//  Created by Dave Townsend on 5/22/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "McDowell.h"
#import "McDowell+Strategy.h"
#import "BAGame.h"
#import "BAUnit.h"
#import "BRMap.h"
#import "CollectionUtil.h"
#import "HMGeometry.h"
#import "HMHex.h"

#define DO_SANITY_CHECK 1

@implementation McDowell (Strategy)

#ifdef DO_SANITY_CHECK
- (void)checkSanity:(BAGame*)game {
    NSArray* units = [[game oob] unitsForSide:[self side]];
    if ([units count] != [[self unitRoles] count])
        DEBUG_AI(@"# USA units = %d but # units assigned to roles = %d",
                 [units count], [[self unitRoles] count]);

    [units enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BAUnit* unit = obj;
        if (![[self unitRoles] objectForKey:[unit name]])
            DEBUG_AI(@"Unit %@ has no roles entry", [unit name]);
    }];

    // Because the collection sizes are the same, we don't also need to check
    // back from 'unitRoles' to 'units'.
}
#endif

- (CUFilter)isCsaUnitAttacking {
    return ^BOOL(BAUnit* unit) {
        HMHex hex = [unit location];
        return [unit sighted]
            && [[game board] is:hex inZone:@"usa"]
            && ![[game board] is:hex inZone:@"csa"];
    };
}


- (int)countCsaAttacking:(BAGame*)game {
    NSArray* units = [[game oob] unitsForSide:OtherPlayer([self side])];
    return [[units grep:[self isCsaUnitAttacking]] count];
}

- (CUFilter)isUsaUnitDefending {
    return ^BOOL(BAUnit* unit) {
        NSNumber* role = [[self unitRoles] objectForKey:[unit name]];
        return role
            && [role isEqualToNumber:[NSNumber numberWithInt:ROLE_DEFEND]]
            && ![unit isOffMap];
    };
}

- (int)countUsaDefending:(BAGame*)game {
    return [[[[game oob] unitsForSide:[self side]]
             grep:[self isUsaUnitDefending]] count];
}

- (void)changeOneDefenderToAttacker {
    // Find the defending unit nearest a ford

    __block BAUnit* minUnit = nil;  // current closest unit
    __block int     minDist = 1000; // current closest distance

    NSArray* usaUnits = [[game oob] unitsForSide:[self side]];
    [usaUnits enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        BAUnit* curUnit = obj;
        if ([self isUsaUnitDefending](curUnit)) {
            HMHexAndDistance hexd = [[BRMap map] closestFordTo:[curUnit location]];

            if (hexd.distance < minDist) {
                minUnit = curUnit;
                minDist = hexd.distance;
            }
        }
     }];

    if (minUnit) {
        DEBUG_AI(@"Switching %@'s role to ATTACK", [minUnit name]);
        [self switch:minUnit roleTo:ROLE_ATTACK];
    } else
        DEBUG_AI(@"No unit is available for attack!");
}

- (void)convertNonDefenderToDefender {
    // Find the non-defending unit nearest home base
    __block BAUnit* minUnit = nil;
    __block int     minDist = 1000;

    NSArray* bases = [[BRMap map] basesForSide:[self side]];
    NSArray* usaUnits = [[game oob] unitsForSide:[self side]];

    [bases enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        HMHex base;
        [obj getValue:&base];

        [usaUnits enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            BAUnit* curUnit = obj;

            if (![self isUsaUnitDefending](curUnit) && ![curUnit isOffMap]) {
                int dist = [[BRMap map] distanceFrom:[curUnit location] to:base];
                if (dist < minDist) {
                    minUnit = curUnit;
                    minDist = dist;
                }
            }
        }];
    }];

    if (minUnit) {
        DEBUG_AI(@"Switching %@'s role to DEFEND", [minUnit name]);
        [self switch:minUnit roleTo:ROLE_DEFEND];

    } else {
        DEBUG_AI(@"No unit is available for defense!");
    }
}

- (void)switch:(BAUnit*)unit roleTo:(int)newRole {
    [[self unitRoles]
     setObject:[NSNumber numberWithInt:newRole]
     forKey:[unit name]];
}

- (void)strategize:(BAGame*)game {

#ifdef DO_SANITY_CHECK
    [self checkSanity:game];
#endif

    int numCsaAttacking = [self countCsaAttacking:game];
    int numUsaDefending = [self countUsaDefending:game];
    DEBUG_AI(@"Strategic situation: %d CSA attackers vs %d USA defenders",
             numCsaAttacking,
             numUsaDefending);

    int surplus = numUsaDefending - numCsaAttacking;

    if (surplus > 0)
        for (int i = 0; i < surplus; ++i)
            [self changeOneDefenderToAttacker];

    else if (surplus < 0)
        for (int i = 0; i < -surplus; ++i)
            [self convertNonDefenderToDefender];
}

@end
