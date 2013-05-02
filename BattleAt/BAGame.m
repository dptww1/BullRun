//
//  BAGame.m
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BABattleReport.h"
#import "BAGame.h"
#import "BAGameObserving.h"
#import "BAMoveOrders.h"
#import "BAOrderOfBattle.h"
#import "BAUnit.h"
#import "BRAppDelegate.h"
#import "BullRun.h"
#import "CollectionUtil.h"
#import "HMMap.h"


BAGame* game; // the global game instance


@implementation BAGame

#pragma mark - Init Methods

- (id)init {
    self = [super init];
    
    if (self) {
        _board     = [HMMap createFromFile:[[NSBundle mainBundle] pathForResource:@"map" ofType:@"plist"]];
        _oob       = [BAOrderOfBattle createFromFile:[[NSBundle mainBundle] pathForResource:@"units" ofType:@"plist"]];
        _observers = [NSMutableArray array];
        _turn      = 1;
        _userSide  = CSA;
    }

    return self;
}

- (BRAppDelegate*)app {
    return (BRAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)hackUserSide:(PlayerSide)side {
    _userSide = side;
    [self doSighting:_userSide];
}

#pragma mark - Public Methods

- (void)addObserver:(id<BAGameObserving>)object {
    [[self observers] addObject:object];
}

- (BAUnit*)unitInHex:(HMHex)hex {
    NSArray* units = [[self oob] units];
    NSUInteger idx = [units indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
        return HMHexEquals(((BAUnit*) obj).location, hex);
    }];
    return idx != NSNotFound ? [units objectAtIndex:idx] : nil;
}

- (void)processTurn {
    [self notifyObserversWithSelector:@selector(movePhaseWillBegin)];

    // TODO: call AI
    
    NSArray*      sortedUnits = [self sortUnits];                       // elements: Unit*
    NSMutableSet* didntMove = [NSMutableSet setWithArray:sortedUnits];  // keys: Unit*; if present, this unit didn't move this turn
    
    // All units get 5 new MPs
    for (BAUnit* u in sortedUnits) {
        [u setMps:[u mps] + 5];
    }
    
    // Because lower-rated units can block higher-rated units, we have to keep processing until no moves were possible.
    BOOL atLeastOneUnitMoved = YES;
    while (atLeastOneUnitMoved) {
        atLeastOneUnitMoved = NO;
        
        for (BAUnit* u in sortedUnits) {
            // Offmap or not moving?
            if (![[_board geometry] legal:[u location]] || ![u hasOrders])
                continue;
            
            HMHex nextHex = [[u moveOrders] firstHexAndRemove:NO];
        
            // Is it occupied?
            BAUnit* blocker = [self unitInHex:nextHex];
            if (blocker) {
                if ([u friends:blocker]) { // friendly blocker; keep looping
                    DEBUG_MOVEMENT(@"%@ can't move into %02d%02d because a friend (%@) is there", [u name], nextHex.column, nextHex.row, [blocker name]);
                    continue;
                
                } else { // enemy blocker: combat!

                    DEBUG_MOVEMENT(@"%@ can't move into %02d%02d because an enemy (%@) is there", [u name], nextHex.column, nextHex.row, [blocker name]);

                    // Must have enough MPs to attack, and be in an offensive mode
                    if ([u mps] >= 4 && IsOffensiveMode([u mode])) { // TODO: IsOffensiveMode is BR-specific
                        [self attackFrom:u to:blocker];

                    } else {
                        DEBUG_COMBAT(@"%@ can't attack %@ due to mode and/or MP cost", [u name], [blocker name]);
                    }
                }
                
            } else {  // destination hex is empty
                
                // ZOC problem?
                if ([self is:u movingThruEnemyZocTo:nextHex]) {
                    DEBUG_MOVEMENT(@"%@ can't move into %02d%02d because of a ZOC problem", [u name], nextHex.column, nextHex.row);
                    continue;
                }

                // At this point the unit made a good-faith effort to move, so don't reset MPs.  This allows units to
                // enter fords, which cost more than an entire turn's supply of MPs.
                [didntMove removeObject:u];
                
                // Check terrain cost
                int mpCost = (int) [[self board] mpCostOf:nextHex for:u];
                if (mpCost > [u mps]) {
                    DEBUG_MOVEMENT(@"%@ can't move into %02d%02d because it costs %d MPs but unit has only %d MPs", [u name], nextHex.column, nextHex.row, mpCost, [u mps]);
                    continue;
                }

                // No impediments, so make the move
                [self notifyObserversUnit:u willMoveToHex:nextHex];

                [[u moveOrders] firstHexAndRemove:YES];
                [u setLocation:nextHex];
                [u setMps:[u mps] - mpCost];
                
                DEBUG_MOVEMENT(@"%@ moved into %02d%02d, deducted %d MPs, leaving %d", [u name], nextHex.column, nextHex.row, mpCost, [u mps]);
               
                atLeastOneUnitMoved = YES;
            }
        }
    }
    
    // Reset MPs of units unwilling or unable to move due to blocked destinations and/or ZOC problems
    for (BAUnit* u in didntMove)
        [u setMps:0];

    [self setTurn:[self turn] + 1];
    
    [self notifyObserversWithSelector:@selector(movePhaseDidEnd)];

    // TODO: compute whether game over
}

#pragma mark - Private Methods

- (void)notifyObserversWithSelector:(SEL)selector {
    for (id<BAGameObserving> observer in [self observers]) {
        if ([observer respondsToSelector:selector])
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [observer performSelector:selector];
#pragma clang diagnostic pop
    }
}

- (void)notifyObserversWithSelector:(SEL)selector andObject:(id)object {
    for (id<BAGameObserving> observer in [self observers]) {
        if ([observer respondsToSelector:selector])
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [observer performSelector:selector withObject:object];
#pragma clang diagnostic pop
    }
}

- (void) notifyObserversUnit:(BAUnit*)unit willMoveToHex:(HMHex)hex {
    for (id<BAGameObserving> observer in [self observers]) {
        [observer moveUnit:unit to:hex];
    }
}

// Returns one or more of the COMBAT_MOVEMENT_XXXX constants
- (void)attackFrom:(BAUnit*)a to:(BAUnit*)d {
    DEBUG_COMBAT(@"COMBAT: %@ attacks %@", [a name], [d name]);

    BABattleReport* report = [BABattleReport battleReportWithAttacker:a
                                                          andDefender:d];

    // Compute base casualties
    int attCasualties = [self computeAttackerCasualtiesFor:a against:d];
    int defCasualties = [self computeDefenderCasualtiesFor:d against:a];

    // Adjust for terrain (TODO: BR-specific)
    HMTerrainEffect* fx = [[game board] terrainAt:[d location]];
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

    int retreatProbability = ((5 - [a mode]) - (5 - [d mode])) * 25;
    retreatProbability += ([a leadership] / 2) - ([d leadership] / 2);
    if ([d mode] == WITHDRAW || (random() % 100) < retreatProbability) {
        // The defender is supposed to retreat.
        DEBUG_COMBAT(@"  defender must retreat, probability was %d", retreatProbability);

        int retreatDir = [self findRetreatDirFor:d attackedBy:a];
        if (retreatDir == -1) { // then no retreat possible
            defCasualties *= 2;
            DEBUG_COMBAT(@"  no retreat possible, doubling casualties to %d", defCasualties);

        } else { // defender retreats
            DEBUG_COMBAT(@"  defender retreats in direction %d", retreatDir);

            HMHex defenderOriginalHex = [d location];
            HMHex retreatHex = [[[self board] geometry] hexAdjacentTo:[d location] inDirection:retreatDir];
            [report setRetreatHex:retreatHex];

            if ([self doesAttackerAdvance:a])
                [report setAdvanceHex:defenderOriginalHex];
        }
    }

    [report setAttackerCasualties:attCasualties];
    [report setDefenderCasualties:defCasualties];

    // Let observers know what's going to happen
    [self notifyObserversWithSelector:@selector(showAttack:) andObject:report];

    // Now implement the results

    // TODO: takeCasualties; in addition to changing strength, set to
    // Defend mode if in an attack mode and now wrecked.
    [a setStrength:[a strength] - attCasualties];
    [d setStrength:[d strength] - defCasualties];

    if ([[[self board] geometry] legal:[report retreatHex]]) {
        [d setLocation:[report retreatHex]];
    }

    if ([[[self board] geometry] legal:[report advanceHex]]) {
        [a setLocation:[report advanceHex]];
    }

    // The units involved in combat can't do anything else this turn.
    [a setMps:0];
    [d setMps:0];
}

- (BOOL)doesAttackerAdvance:(BAUnit*)a {
    static int modeAdjustmentMatrix[NUM_MODES] = { 50, 25, 10, 0, 0, 0 };

    int pctChance = modeAdjustmentMatrix[[a mode]] + [a leadership];

    int d100 = random() % 100;

    DEBUG_COMBAT(@"  %@ advance pct: %d, roll %d, so %s advance",
                 [a name], pctChance, d100, d100 <= pctChance ? "will" : "wont");

    return d100 <= pctChance;
}

- (int)computeAttackerCasualtiesFor:(BAUnit*)a against:(BAUnit*)d {
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

- (int)computeDefenderCasualtiesFor:(BAUnit*)d against:(BAUnit*)a {
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

- (BOOL)is:(BAUnit*)unit movingThruEnemyZocTo:(HMHex)hex {
    HMGeometry* g = [_board geometry];
    
    int moveDir = [g directionFrom:[unit location] to:hex];
    int cwDir   = [g rotateDirection:moveDir clockwise:YES];
    int ccwDir  = [g rotateDirection:moveDir clockwise:NO];
    
    BAUnit* cwUnit  = [self unitInHex:[g hexAdjacentTo:[unit location] inDirection:cwDir]];
    BAUnit* ccwUnit = [self unitInHex:[g hexAdjacentTo:[unit location] inDirection:ccwDir]];

    return (cwUnit  && ![cwUnit  friends:unit])
        || (ccwUnit && ![ccwUnit friends:unit]);
}

// -1 == no retreat possible, else direction to retreat in
- (int)findRetreatDirFor:(BAUnit*)d attackedBy:(BAUnit*)a {
    HMGeometry* geometry = [[self board] geometry];

    int attackDir = [geometry directionFrom:[a location] to:[d location]];
    if ([self unit:d canRetreatInDirection:attackDir])
        return attackDir;

    int attackDirCW = [geometry rotateDirection:attackDir clockwise:YES];
    if ([self unit:d canRetreatInDirection:attackDirCW])
        return attackDirCW;

    int attackDirCCW = [geometry rotateDirection:attackDir clockwise:NO];
    if ([self unit:d canRetreatInDirection:attackDirCCW])
        return attackDirCCW;

    return -1;
}

- (BOOL)unit:(BAUnit*)u canRetreatInDirection:(int)dir {
    HMGeometry* geometry = [[self board] geometry];

    HMHex hex = [geometry hexAdjacentTo:[u location] inDirection:dir];

    return [geometry legal:hex]
        && ![self unitInHex:hex]
        && ![[self board] is:hex prohibitedFor:u]
        && ![self is:u movingThruEnemyZocTo:hex];
}

// Performs sighting from the POV of player `side'. In practice will
// most usually be called with side parameter == _userSide attribute,
// but doing it this way allows more convenient testing and debugging.
- (void)doSighting:(PlayerSide)side {

    // TODO: friends and enemies should be methods on OOB

    NSArray* friends = [_oob unitsForSide:side];
    NSArray* enemies = [_oob unitsForSide:OtherPlayer(side)];
    
    [friends enumerateObjectsUsingBlock:^(id friend, NSUInteger idx, BOOL* stop) {
        if ([[_board geometry] legal:[friend location]]) {
            if (![friend sighted]) {
                [friend setSighted:YES];
                [self notifyObserversWithSelector:@selector(unitNowSighted:) andObject:friend];
            }
        }
        // doesn't handle case of on-board unit moving off-board
     }];

    [enemies enumerateObjectsUsingBlock:^(id enemy, NSUInteger idx, BOOL* stop) {
        BOOL enemyNowSighted = NO;
        
        // Ignore units unless they are on the map
        if ([[_board geometry] legal:[enemy location]]) {
        
            // CSA north of river or USA south of river is always spotted (note that fords
            // are marked as on both sides of the river, so units on fords are always spotted).
            if ([self.board isEnemy:[enemy location] of:[enemy side]]) {
                DEBUG_SIGHTING(@"%@ is in enemy territory", [enemy name]);
                enemyNowSighted = YES;
                
            } else {
                enemyNowSighted = [self isUnit:enemy inHex:[enemy location] sightedBy:friends];
            }

            // if enemy is no longer sighted, but used to be, update it
            if (!enemyNowSighted && [enemy sighted]) {
                [enemy setSighted:NO];
                [self notifyObserversWithSelector:@selector(unitNowHidden:) andObject:enemy];

            } else if (enemyNowSighted && ![enemy sighted]) {
                [enemy setSighted:YES];
                [self notifyObserversWithSelector:@selector(unitNowSighted:) andObject:enemy];
            }
        }
        // Note that we're not handling the case of an on-board unit moving off-board.
    }];
}

// Returns YES if `enemy' situated in given terrain is sighted by any of `friends'.
- (BOOL)isUnit:(BAUnit*)enemy inHex:(HMHex)hex sightedBy:(NSArray*)friends {
    
    // Innocent until proven guilty.
    __block BOOL sighted = NO;
    
    [friends enumerateObjectsUsingBlock:^(id friend, NSUInteger idx, BOOL* stop) {
        // Friends which are offboard can't spot.
        if (![[_board geometry] legal:[friend location]])
            return;
        
        // Friendly units within three hexes sight enemies...
        if ([[_board geometry] distanceFrom:[friend location] to:[enemy location]] < 4) {
            
            // ...as long as both units are on the same side of the river
            if ([self.board is:[friend location] inSameZoneAs:hex]) {
                DEBUG_SIGHTING(@"%@ spots %@", [friend name], [enemy name]);
                *stop = sighted = YES;
            }
        }
    }];
    
    return sighted;
}

- (NSArray*)sortUnits {
    return [[_oob units] sortedArrayWithOptions:NSSortStable
                                usingComparator:^(id obj1, id obj2) {
                                    BAUnit* u1 = obj1;
                                    BAUnit* u2 = obj2;
                                    
                                    // Leftover MPs are the first ordering determinant
                                    if ([u1 mps] > [u2 mps])
                                        return NSOrderedAscending;
                                    
                                    else if ([u1 mps] < [u2 mps])
                                        return NSOrderedDescending;
                                    
                                    // When MPs are equal, Leadership is the tiebreaker
                                    if ([u1 leadership] > [u2 leadership])
                                        return NSOrderedAscending;
                                    
                                    else if ([u1 leadership] < [u2 leadership])
                                        return NSOrderedDescending;
                                    
                                    return NSOrderedSame;
                                }];
}

@end
