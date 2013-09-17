//
//  BR1GameDelegate.m
//  Bull Run
//
//  Created by Dave Townsend on 8/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BR1GameDelegate.h"
#import "BR1Map.h"
#import "BattleAt.h"

@implementation BR1GameDelegate

#pragma mark - BATGameDelegate implementation

- (void)allotMovementPoints {
    for (BATUnit* u in [[game oob] units])
        [u setMps:[u mps] + 5];
}

- (BOOL)isUnit:(BATUnit*)enemy inHex:(HXMHex)hex sightedBy:(NSArray*)friends {
    // CSA north of river or USA south of river is always spotted (note that fords
    // are marked as on both sides of the river, so units on fords are always spotted).
    if ([[BR1Map map] isHex:[enemy location] enemyOfPlayer:[enemy side]]) {
        DEBUG_SIGHTING(@"%@ is in enemy territory", [enemy name]);
        return YES;
    }

    // Innocent until proven guilty.
    __block BOOL sighted = NO;

    [friends enumerateObjectsUsingBlock:^(BATUnit* friend, NSUInteger idx, BOOL* stop) {
        HXMMap* map = [game board];

        // Friends which are offboard can't spot.
        if (![map isHexOnMap:[friend location]])
            return;

        BOOL friendInUsaZone = [map is:[friend location] inZone:@"usa"];
        BOOL friendInCsaZone = [map is:[friend location] inZone:@"csa"];

        // Friendly units within three hexes sight enemies...
        if ([map distanceFrom:[friend location] to:[enemy location]] < 4) {

            // ...as long as both units are on the same side of the river
            BOOL enemyInUsaZone = [map is:[enemy location] inZone:@"usa"];
            BOOL enemyInCsaZone = [map is:[enemy location] inZone:@"csa"];

            if ((friendInUsaZone && enemyInUsaZone) ||
                (friendInCsaZone && enemyInCsaZone)) {
                DEBUG_SIGHTING(@"%@ spots %@", [friend name], [enemy name]);
                *stop = sighted = YES;
            }
        }
    }];
    
    return sighted;
}

- (NSString*)convertTurnToString:(int)turn {
    // Turns begin at 6:30 AM, increment by 30 minutes per turn
    // Turn 1 => 6:30 AM
    // Turn 2 => 7:00 AM
    // Turn 3 => 7:30 AM
    // ...
    const char* amPm    = "AM";
    int         hour    = (turn / 2) + 6;
    int         minutes = turn & 1 ? 30 : 0;

    if (hour >= 12) {
        amPm = "PM";
        if (hour > 12)
            hour -= 12;
    }

    return [NSString stringWithFormat:@"%d:%02d %s",
            hour,
            minutes,
            amPm];
}

- (int)convertStringToTurn:(NSString*)string {
    NSCharacterSet* separators = [NSCharacterSet
                                  characterSetWithCharactersInString:@": "];
    NSArray* elts = [string componentsSeparatedByCharactersInSet:separators];

    if ([elts count] != 3)
        @throw [NSException
                exceptionWithName:@"IllegalTimeString"
                           reason:@"String missing (or too many) separators"
                         userInfo:nil];

    int hour = [elts[0] intValue];
    if ([elts[2] isEqualToString:@"PM"] && hour != 12)
        hour += 12;

    hour -= 6;
    int turn = hour * 2;

    // Minutes
    if ([elts[1] isEqualToString:@"30"])
        turn += 1;

    return turn;
}

- (NSArray*)getPossibleModesForUnit:(BATUnit*)unit {
    if ([unit isWrecked])
        return @[ @"Defend", @"Withdraw" ];

    return @[ @"Charge", @"Attack", @"Skirmish", @"Defend", @"Withdraw" ];
}

- (int)getModeIndexForUnit:(BATUnit*)unit inMode:(NSString*)modeString {
    NSArray* modeStrings = [self getPossibleModesForUnit:nil];
    for (int i = 0; i < [modeStrings count]; ++i) {
        if ([modeStrings[i] isEqualToString:modeString])
             return i;
    }

    @throw [NSException exceptionWithName:@"Bad Mode string"
                                   reason:modeString
                                 userInfo:nil];
}

- (NSString*)getCurrentModeStringForUnit:(BATUnit*)unit {
    NSArray* modeStrings = [self getPossibleModesForUnit:nil];
    return modeStrings[[unit mode]];
}

- (BOOL)canUnit:(BATUnit*)unit attackHex:(HXMHex)hex {
    // Must have enough MPs to attack, and be in an offensive mode
    return [unit mps] >= 4 && IsOffensiveMode([unit mode]);
}

- (BATBattleReport*)resolveCombatFrom:(BATUnit*)attacker attacking:(BATUnit*)defender {
    BATBattleReport* report = [BATBattleReport battleReportWithAttacker:attacker
                                                            andDefender:defender];

    // Compute base casualties
    int attCasualties = [self computeAttackerCasualtiesFor:attacker against:defender];
    int defCasualties = [self computeDefenderCasualtiesFor:defender against:attacker];

    // Adjust for terrain (TODO: BR-specific)
    HXMTerrainEffect* fx = [[game board] terrainAt:[defender location]];
    if ([[fx name] isEqualToString:@"Ford"]) {   // att + 100%, def - 50%
        attCasualties *= 2;
        defCasualties /= 2;
        DEBUG_COMBAT(@"  Ford hex has attacker now at %d and defender at %d", attCasualties, defCasualties);
    }

    if ([[fx name] isEqualToString:@"Woods"]) {  // att + 25%, def - 25%
        attCasualties += attCasualties / 4;
        defCasualties = (defCasualties * 3) / 4;
        DEBUG_COMBAT(@"  Woods hex has attacker now at %d and defender at %d", attCasualties, defCasualties);
    }

    int retreatProbability = ((5 - [attacker mode]) - (5 - [defender mode])) * 25;
    retreatProbability += ([attacker leadership] / 2) - ([defender leadership] / 2);
    if ([defender mode] == kBATModeWithdraw || (random() % 100) < retreatProbability) {
        // The defender is supposed to retreat.
        DEBUG_COMBAT(@"  defender must retreat, probability was %d", retreatProbability);

        int retreatDir = [self findRetreatDirFor:defender attackedBy:attacker];
        if (retreatDir == -1) { // then no retreat possible
            defCasualties *= 2;
            DEBUG_COMBAT(@"  no retreat possible, doubling casualties to %d", defCasualties);

        } else { // defender retreats
            DEBUG_COMBAT(@"  defender retreats in direction %d", retreatDir);

            HXMHex defenderOriginalHex = [defender location];
            HXMHex retreatHex = [[game board] hexAdjacentTo:[defender location] inDirection:retreatDir];
            [report setRetreatHex:retreatHex];

            if ([self doesAttackerAdvance:attacker])
                [report setAdvanceHex:defenderOriginalHex];
        }
    }

    return report;
}


- (BOOL)doesAttackerAdvance:(BATUnit*)a {
    static int modeAdjustmentMatrix[NUM_MODES] = { 50, 25, 10, 0, 0, 0 };

    int pctChance = modeAdjustmentMatrix[[a mode]] + [a leadership];

    int d100 = random() % 100;

    DEBUG_COMBAT(@"  %@ advance pct: %d, roll %d, so %s advance",
                 [a name], pctChance, d100, d100 <= pctChance ? "will" : "wont");

    return d100 <= pctChance;
}


- (int)computeAttackerCasualtiesFor:(BATUnit*)a against:(BATUnit*)d {
    static int modeCasualtyMatrix[NUM_MODES][NUM_MODES] = {
        // CH AT SK DE WI RT  // Attacker mode
        5, 4, 3, 0, 0, 0,  // Defender is CHARGE
        4, 3, 2, 0, 0, 0,  // Defender is ATTACK
        3, 2, 1, 0, 0, 0,  // Defender is SKIRMISH
        5, 4, 2, 0, 0, 0,  // Defender is DEFEND
        2, 1, 1, 0, 0, 0,  // Defender is WITHDRAW
        0, 0, 0, 0, 0, 0   // Defender is ROUTED
    };

    int c = ([d strength] / 256) + ((random() & 0xff) * ([d strength] / 256)) / 256;
    DEBUG_COMBAT(@"  %@ base casualties: %d", [a name], c);
    c *= modeCasualtyMatrix[[d mode]][[a mode]];
    DEBUG_COMBAT(@"    adjusted by mode matrix to %d", c);
    return c;
}

- (int)computeDefenderCasualtiesFor:(BATUnit*)d against:(BATUnit*)a {
    static int modeCasualtyMatrix[NUM_MODES][NUM_MODES] = {
        // CH AT SK DE WI RT  // Attacker mode
        5, 4, 3, 0, 0, 0,  // Defender is CHARGE
        4, 3, 2, 0, 0, 0,  // Defender is ATTACK
        3, 2, 1, 0, 0, 0,  // Defender is SKIRMISH
        2, 1, 1, 0, 0, 0,  // Defender is DEFEND
        4, 3, 2, 0, 0, 0,  // Defender is WITHDRAW
        0, 0, 0, 0, 0, 0   // Defender is ROUTED
    };

    int c = ([a strength] / 256) + ((random() & 0xff) * ([a strength] / 256)) / 256;
    DEBUG_COMBAT(@"  %@ base casualties: %d", [d name], c);
    c *= modeCasualtyMatrix[[d mode]][[a mode]];
    DEBUG_COMBAT(@"    adjusted by mode matrix to %d", c);
    return c;
}

// -1 == no retreat possible, else direction to retreat in
- (int)findRetreatDirFor:(BATUnit*)d attackedBy:(BATUnit*)a {
    HXMMap* board = [game board];
    int attackDir = [board directionFrom:[a location] to:[d location]];
    if ([self unit:d canRetreatInDirection:attackDir])
        return attackDir;

    int attackDirCW = [board rotateDirection:attackDir clockwise:YES];
    if ([self unit:d canRetreatInDirection:attackDirCW])
        return attackDirCW;

    int attackDirCCW = [board rotateDirection:attackDir clockwise:NO];
    if ([self unit:d canRetreatInDirection:attackDirCCW])
        return attackDirCCW;

    return -1;
}

- (BOOL)unit:(BATUnit*)u canRetreatInDirection:(int)dir {
    HXMMap* board = [game board];
    HXMHex hex = [board hexAdjacentTo:[u location] inDirection:dir];

    return [board isHexOnMap:hex]
        && ![game unitInHex:hex]
        && ![board isProhibited:hex]
        && ![game is:u movingThruEnemyZocTo:hex];
}

@end
