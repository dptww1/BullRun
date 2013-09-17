//
//  BATGame.m
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BattleAt.h"
#import "BATBattleReport.h"
#import "BATGame.h"
#import "BATGameObserving.h"
#import "BATMoveOrders.h"
#import "BATOrderOfBattle.h"
#import "BATReinforcementInfo.h"
#import "BATUnit.h"
#import "NSArray+DPTUtil.h"


BATGame* game; // the global game instance

//==============================================================================
@interface BATGame ()

@property (nonatomic, strong, readonly)  NSMutableArray*  observers;
@property (nonatomic, assign, readwrite) int              turn;

@end

//==============================================================================
@implementation BATGame

#pragma mark - Init Methods

+ (BATGame*)gameWithDelegate:(id<BATGameDelegate>)delegate {
    return [[BATGame alloc] initWithDelegate:delegate];
}

- (id)initWithDelegate:(id<BATGameDelegate>)delegate {
    self = [super init];
    
    if (self) {
        // _ai must be set by derived classes
        _board     = [HXMMap createFromFile:[[NSBundle mainBundle] pathForResource:@"map" ofType:@"plist"]];
        _delegate  = delegate;
        _oob       = [BATOrderOfBattle createFromFile:[[NSBundle mainBundle] pathForResource:@"units" ofType:@"plist"]];
        _observers = [NSMutableArray array];
        _turn      = 1;
        _userSide  = kBATPlayerSide1;
    }

    return self;
}

- (void)hackUserSide:(BATPlayerSide)side {
    _userSide = side;
    [self doSighting:_userSide];
}

#pragma mark - Public Methods

- (BOOL)is:(BATUnit*)unit movingThruEnemyZocTo:(HXMHex)hex {
    int moveDir = [_board directionFrom:[unit location] to:hex];
    int cwDir   = [_board rotateDirection:moveDir clockwise:YES];
    int ccwDir  = [_board rotateDirection:moveDir clockwise:NO];

    BATUnit* cwUnit  = [self unitInHex:[_board hexAdjacentTo:[unit location] inDirection:cwDir]];
    BATUnit* ccwUnit = [self unitInHex:[_board hexAdjacentTo:[unit location] inDirection:ccwDir]];

    return (cwUnit  && ![cwUnit  friends:unit])
    || (ccwUnit && ![ccwUnit friends:unit]);
}

- (void)addObserver:(id<BATGameObserving>)object {
    [_observers addObject:object];
}

- (BATUnit*)unitInHex:(HXMHex)hex {
    NSArray* units = [_oob units];
    return [units dpt_find:^BOOL(BATUnit* unit) {
        return HXMHexEquals([unit location], hex);
    }];
}

- (BOOL)unitIsSurrounded:(BATUnit*)unit {
    // We'll use an int wherein each direction # gets assigned the
    // corresponding bit. Zeros mean the direction is clear, ones mean
    // the direction is blocked.
    int dirs = 0x00;

    // Find the neighboring hex in every direction
    for (int i = 0; i < 6; ++i) {
        HXMHex adjHex = [_board hexAdjacentTo:[unit location] inDirection:i];

        // Offmap or Prohibited hexes are blocked
        if (![_board isHexOnMap:adjHex] || [_board isProhibited:adjHex]) {
            dirs |= (1 << i);
            continue;
        }

        // Empty hexes need no further processing
        BATUnit* occupier = [self unitInHex:adjHex];
        if (!occupier)
            continue;

        // At this point the hex is occupied; both friends and foes block
        dirs |= (1 << i);

        // Enemy also exert ZOCs into the adjacent hexes.
        if (![unit friends:occupier]) {
            dirs |= (1 << [_board rotateDirection:i clockwise:YES]);
            dirs |= (1 << [_board rotateDirection:i clockwise:NO]);
        }
    }

    // If all six bits are set, the unit is indeed surrounded.
    return dirs == 0x3f;
}

// Performs sighting from the POV of player `side'. In practice will
// most usually be called with side parameter == _userSide attribute,
// but doing it this way allows more convenient testing and debugging.
- (void)doSighting:(BATPlayerSide)side {

    NSMutableSet* newlySighted = [NSMutableSet set]; // contains BATUnit*
    NSMutableSet* newlyHidden  = [NSMutableSet set]; // contains BATUnit*

    // TODO: friends and enemies should be methods on OOB

    NSArray* friends = [_oob unitsForSide:side];
    NSArray* enemies = [_oob unitsForSide:OtherPlayer(side)];

    [friends enumerateObjectsUsingBlock:^(BATUnit* friend, NSUInteger idx, BOOL* stop) {
        if ([_board isHexOnMap:[friend location]]) {
            if (![friend sighted]) {
                [friend setSighted:YES];
                [newlySighted addObject:friend];
                //[self notifyObserversWithSelector:@selector(unitNowSighted:) andObject:friend];
            }
        }
        // doesn't handle case of on-board unit moving off-board
    }];

    [enemies enumerateObjectsUsingBlock:^(BATUnit* enemy, NSUInteger idx, BOOL* stop) {
        BOOL enemyNowSighted = NO;

        // Ignore units unless they are on the map
        if ([_board isHexOnMap:[enemy location]]) {
            enemyNowSighted = [_delegate isUnit:enemy inHex:[enemy location] sightedBy:friends];

            // if enemy is no longer sighted, but used to be, update it
            if (!enemyNowSighted && [enemy sighted]) {
                [enemy setSighted:NO];
                [newlyHidden addObject:enemy];

            } else if (enemyNowSighted && ![enemy sighted]) {
                [enemy setSighted:YES];
                [newlySighted addObject:enemy];
            }
        }
        // Note that we're not handling the case of an on-board unit moving off-board.
    }];

    // No point in updating unless something actually changed.
    if ([newlySighted count] || [newlyHidden count])
        [self notifyObserversWithSelector:@selector(sightingChangedWithNowSightedUnits:andNowHiddenUnits:)
                                   object:newlySighted
                                andObject:newlyHidden];
}

- (void)allotMovementPoints {
    @throw [NSException
            exceptionWithName:@"BATMissingOverride"
                       reason:@"Classes derived from BAGame must implement allotMovementPoints"
                     userInfo:@{}];
}

- (void)processTurn {
    [self notifyObserversWithSelector:@selector(movePhaseWillBegin)];

    [_ai giveOrders:self];
    
    NSArray*      sortedUnits = [self sortUnits];                       // elements: BATUnit*
    NSMutableSet* didntMove = [NSMutableSet setWithArray:sortedUnits];  // keys: BATUnit*; if present, this unit didn't move this turn

    [_delegate allotMovementPoints];
    
    // Because lower-rated units can block higher-rated units, we have to keep processing until no moves were possible.
    BOOL atLeastOneUnitMoved = YES;
    
    while (atLeastOneUnitMoved) {
        atLeastOneUnitMoved = NO;
        
        for (BATUnit* u in sortedUnits) {
            // Offmap or not moving?
            if (![_board isHexOnMap:[u location]] || ![u hasOrders])
                continue;
            
            HXMHex nextHex = [[u moveOrders] firstHexAndRemove:NO];

            // Trying to enter illegal hex?
            if ([_board isProhibited:nextHex])
                continue;

            // Is it occupied?
            BATUnit* blocker = [self unitInHex:nextHex];
            if (blocker) {
                if ([u friends:blocker]) { // friendly blocker; keep looping
                    DEBUG_MOVEMENT(@"%@ can't move into %02d%02d because a friend (%@) is there", [u name], nextHex.column, nextHex.row, [blocker name]);
                    continue;
                
                } else { // enemy blocker: combat!

                    DEBUG_MOVEMENT(@"%@ can't move into %02d%02d because an enemy (%@) is there", [u name], nextHex.column, nextHex.row, [blocker name]);

                    if ([_delegate canUnit:u attackHex:nextHex]) {
                        [self attackFrom:u to:blocker];
                        [self doSighting:_userSide];

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
                int mpCost = (int) [_board mpCostOf:nextHex];
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

                [self doSighting:_userSide];

                atLeastOneUnitMoved = YES;
            }
        }
    }
    
    // Reset MPs of units unwilling or unable to move due to blocked destinations and/or ZOC problems
    for (BATUnit* u in didntMove)
        [u setMps:0];

    [self processReinforcements];
    [self setTurn:[self turn] + 1];
    [self notifyObserversWithSelector:@selector(movePhaseDidEnd)];

    // TODO: compute whether game over
}

#pragma mark - Private Methods

- (void)notifyObserversWithSelector:(SEL)selector {
    for (id<BATGameObserving> observer in [self observers]) {
        if ([observer respondsToSelector:selector])
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [observer performSelector:selector];
#pragma clang diagnostic pop
    }
}

- (void)notifyObserversWithSelector:(SEL)selector andObject:(id)object {
    for (id<BATGameObserving> observer in [self observers]) {
        if ([observer respondsToSelector:selector])
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [observer performSelector:selector withObject:object];
#pragma clang diagnostic pop
    }
}

- (void)notifyObserversWithSelector:(SEL)selector object:(id)param1 andObject:(id)param2 {
    for (id<BATGameObserving> observer in [self observers]) {
        if ([observer respondsToSelector:selector])
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [observer performSelector:selector withObject:param1 withObject:param2];
#pragma clang diagnostic pop
    }
}

- (void) notifyObserversUnit:(BATUnit*)unit willMoveToHex:(HXMHex)hex {
    for (id<BATGameObserving> observer in [self observers]) {
        [observer moveUnit:unit to:hex];
    }
}

- (void)processReinforcements {
    BOOL anyReinforcementsAppeared = NO;

    for (int i = 0; i < [[_oob reinforcements] count]; ++i) {
        BATReinforcementInfo* rInfo = [[_oob reinforcements] objectAtIndex:i];

        if ([self turn] >= [rInfo entryTurn]) {

            BATUnit* unit     = [_oob unitByName:[rInfo unitName]];
            HXMHex   entryHex = [rInfo entryLocation];

            if ([[self board] isHexOnMap:entryHex]) {

                BATUnit* occupier = [self unitInHex:entryHex];
                if (occupier) {
                    DEBUG_REINFORCEMENTS(@"%@ can't enter because %@ is in the way",
                                         [unit name], [occupier name]);
                    continue;
                }

                [unit setLocation:entryHex];

                DEBUG_REINFORCEMENTS(@"%@ appears at %02d%02d",
                                     [unit name], entryHex.column, entryHex.row);

                [[_oob reinforcements] removeObjectAtIndex:i];

                // Since we've removed the reinforcement node, the index of
                // the next node will actually be the same index as the current
                // node.  Since the loop increments the index, we have to
                // decrement it here to keep thinks aligned.
                --i;

                anyReinforcementsAppeared = YES;
            } else {
                DEBUG_REINFORCEMENTS(@"%@ has bad reinforcement hex %02d%02d!",
                                     [unit name], entryHex.column, entryHex.row);
            }

        }
    }

    if (anyReinforcementsAppeared)
        [self doSighting:_userSide];
}

- (void)attackFrom:(BATUnit*)a to:(BATUnit*)d {
    DEBUG_COMBAT(@"COMBAT: %@ attacks %@", [a name], [d name]);

    BATBattleReport* report = [_delegate resolveCombatFrom:a attacking:d];
    [report setAttackerCasualties:[report attackerCasualties]];
    [report setDefenderCasualties:[report defenderCasualties]];

    // Let observers know what's going to happen
    [self notifyObserversWithSelector:@selector(showAttack:) andObject:report];

    // Now implement the results

    // TODO: takeCasualties; in addition to changing strength, set to
    // Defend mode if in an attack mode and now wrecked.
    [a setStrength:[a strength] - [report attackerCasualties]];
    [d setStrength:[d strength] - [report defenderCasualties]];

    if ([_board isHexOnMap:[report retreatHex]]) {
        [d setLocation:[report retreatHex]];
    }

    if ([_board isHexOnMap:[report advanceHex]]) {
        [a setLocation:[report advanceHex]];
    }

    // The units involved in combat can't do anything else this turn.
    [a setMps:0];
    [d setMps:0];
}

- (NSArray*)sortUnits {
    return [[_oob units]
            sortedArrayWithOptions:NSSortStable
            usingComparator:^(BATUnit* u1, BATUnit* u2) {
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
