//
//  Beauregard+Tactics.m
//  Bull Run
//
//  Created by Dave Townsend on 6/16/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATAIInfluenceMap.h"
#import "BATGame.h"
#import "BAUnit.h"
#import "BATMoveOrders.h"
#import "Beauregard+Strategy.h"
#import "Beauregard+Tactics.h"
#import "BRMap.h"
#import "NSArray+DPTUtil.h"

//==============================================================================
@implementation Beauregard (Private)

- (void)devalueInfluenceMap:(BATAIInfluenceMap*)imap atHex:(HXMHex)hex {
    HXMMap* map = [game board];

    [imap multiplyBy:0.25f atHex:hex];

    for (int dir = 0; dir < 6; ++dir)
        [imap multiplyBy:0.5f atHex:[map hexAdjacentTo:hex inDirection:dir]];
}

- (NSNumber*)computeAttackChanceOf:(BAUnit*)unit inDirection:(int)dir {
    HXMHex hex = [[game board] hexAdjacentTo:[unit location] inDirection:dir];
    if (![[game board] legal:hex])
        return @(0);

    BAUnit* enemy = [game unitInHex:hex];
    if (!enemy || [enemy side] == [self side])
        return @(0);

    int val = 0;

    BRAICSATheater theater = [self computeTheaterOf:unit];
    HXMHex nearestBaseHex = [self baseHexForTheater:theater];

    // Surrounded units should consider breaking out
    if ([game unitIsSurrounded:unit])
        val += 10;

    // Should almost always try to clear a base
    if (HXMHexEquals(hex, nearestBaseHex))
        val += 60;

    // TODO: direction is not towards closest base: -10

    // hex in USA territory: -800
    if ([[game board] is:hex inZone:@"usa"] && ![[game board] is:hex inZone:@"csa"])
        val -= 800;

    // always weight to increase chance of attack when near base
    val += 2 * (10 - [[game board] distanceFrom:hex to:nearestBaseHex]);

    return @(val);
}

@end


//==============================================================================
@implementation Beauregard (Tactics)

- (BOOL)assignAttacker {
    __block BAUnit* attacker = nil;

    NSArray* csaUnits = [self unorderedCsaUnits];
    [csaUnits enumerateObjectsUsingBlock:^(BAUnit* unit, NSUInteger idx, BOOL* stop) {
        if ([unit isWrecked])
            return;

        DEBUG_AI(@"assignAttacker considering %@", [unit name]);

        NSMutableArray* attackChances = [NSMutableArray arrayWithCapacity:6];
        for (int i = 0; i < 6; ++i)
            attackChances[i] = [self computeAttackChanceOf:unit inDirection:i];

        // find max value in attackChances
        int attackDir = [attackChances dpt_max_idx];
        int attackChance = attackChances[attackDir];

        if ([game unitIsSurrounded:unit])
            attackChance *= 2;

        // No possible attacks
        if (attackChance == 0) {
            DEBUG_AI(@"  => not attacking because no enemies adjacent");
            return;
        }

        int dieroll = random() % 100;

        if (dieroll > attackChance * 2) {
            DEBUG_AI(@"  => not attacking because dieroll %d > chance %d",
                     dieroll, attackChance);
            return;
        }

        if (dieroll < attackChance)
            [unit setMode:CHARGE];

        else if (dieroll < attackChance * 1.5)
            [unit setMode:ATTACK];

        else
            [unit setMode:SKIRMISH];
        
        // set unit orders to hex
        [[unit moveOrders]
         addHex:[[game board] hexAdjacentTo:[unit location]
                                inDirection:attackDir]];
        DEBUG_AI(@"  => attacking dir %d in mode %d because roll %d chance %d",
                 attackDir, [unit mode], dieroll, attackChance);
    }];

    return attacker != nil;;
}

- (BOOL)assignDefender:(BATAIInfluenceMap*)imap {
    BRMap* map = [BRMap map];
    HXMHexAndDistance hexd = [imap largestValue];
    if (hexd.distance < 1)
        return NO;

    NSArray* csaUnits = [self unorderedCsaUnits];
    NSArray* distances = [csaUnits dpt_map:^NSNumber*(BAUnit* unit) {
        return @([map distanceFrom:[unit location] to:hexd.hex]);
    }];
    int i = [distances dpt_min_idx];

    if (i >= 0) {
        BAUnit* unit = csaUnits[i];
        DEBUG_AI(@"assignDefender %@ to %02d%02d", [unit name], hexd.hex.column, hexd.hex.row);

        if ([map is:[unit location] inZone:@"usa"]) {
            HXMHexAndDistance fordLoc = [map closestFordTo:[unit location]];
            [self routeUnit:unit toDestination:fordLoc.hex];
        } else {
            [self routeUnit:unit toDestination:hexd.hex];
        }

        [[self orderedThisTurn] addObject:[unit name]];
        [self devalueInfluenceMap:imap atHex:hexd.hex];
    } else
        DEBUG_AI(@"assignDefender fails because no defenders are left");

    return i >= 0;
}
@end
