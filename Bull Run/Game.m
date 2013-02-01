//
//  Game.m
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BRAppDelegate.h"
#import "Board.h"
#import "BullRun.h"
#import "CollectionUtil.h"
#import "Game.h"
#import "MoveOrders.h"
#import "OrderOfBattle.h"
#import "Terrain.h"
#import "Unit.h"

Game* game;

@interface Game (Private)

- (void)doSighting:(PlayerSide)side;

@end

@implementation Game

#pragma mark - Init Methods

- (id)init {
    self = [super init];
    
    if (self) {
        _userSide = CSA;
        _board = [Board createFromFile:[[NSBundle mainBundle] pathForResource:@"map" ofType:@"plist"]];
        _oob = [OrderOfBattle createFromFile:[[NSBundle mainBundle] pathForResource:@"units" ofType:@"plist"]];
    }

    return self;
}

- (void)hackUserSide:(PlayerSide)side {
    _userSide = side;
    [self doSighting:_userSide];
}

#pragma mark - Public Methods

- (void)doNextTurn {
    // TODO: call AI
    
    NSArray*      sortedUnits = [self sortUnits];                       // elements: Unit*
    NSMutableSet* didntMove = [NSMutableSet setWithArray:sortedUnits];  // keys: Unit*; if present, this unit didn't move this turn
    
    // All units get 5 new MPs
    for (Unit* u in sortedUnits) {
        [u setMps:[u mps] + 5];
    }
    
    // Because lower-rated units can block higher-rated units, we have to keep processing until no moves were possible.
    BOOL atLeastOneUnitMoved = YES;
    while (atLeastOneUnitMoved) {
        atLeastOneUnitMoved = NO;
        
        for (Unit* u in sortedUnits) {
            // Offmap or not moving?
            if (![[_board geometry] legal:[u location]] || ![u hasOrders])
                continue;
            
            Hex nextHex = [[u moveOrders] firstHexAndRemove:NO];
        
            // Is it occupied?
            Unit* blocker = [_oob unitInHex:nextHex];
            if (blocker) {
                if ([u friends:blocker]) { // friendly blocker; keep looping
                    DEBUG_MOVEMENT(@"%@ can't move into %02d%02d because a friend (%@) is there", [u name], nextHex.column, nextHex.row, [blocker name]);
                    continue;
                
                } else { // enemy blocker: combat!
                    DEBUG_MOVEMENT(@"%@ can't move into %02d%02d because an enemy (%@) is there", [u name], nextHex.column, nextHex.row, [blocker name]);
                    continue;
                    ;// TODO: resolve combat; [didntmove delete:u]?
                }
                
            } else {  // destination hex is empty
                
                // ZOC problem?
                if ([self is:u movingThruEnemyZocTo:nextHex]) {
                    DEBUG_MOVEMENT(@"%@ can't move into %02d%02d because of a ZOC problem", [u name], nextHex.column, nextHex.row);
                    continue;
                }

                // Check terrain cost
                Terrain* terrain = [[Terrain alloc] initWithInt:[_board terrainAt:nextHex]];
                if ([terrain mpCost] > [u mps]) {
                    DEBUG_MOVEMENT(@"%@ can't move into %02d%02d because it costs %d MPs but unit has only %d MPs", [u name], nextHex.column, nextHex.row, [terrain mpCost], [u mps]);
                    continue;
                }

                // No impediments, so make the move
                [(BRAppDelegate*)[[UIApplication sharedApplication] delegate] moveUnit:u to:nextHex];
                [[u moveOrders] firstHexAndRemove:YES];
                [u setLocation:nextHex];
                [u setMps:[u mps] - [terrain mpCost]];
                
                [didntMove removeObject:u];
                
                DEBUG_MOVEMENT(@"%@ moved into %02d%02d, deducted %d MPs, leaving %d", [u name], nextHex.column, nextHex.row, [terrain mpCost], [u mps]);
               
                // TODO: sighting
              
                atLeastOneUnitMoved = YES;
            }
        }
    }
    
    // Reset MPs of units unwilling or unable to move due to blocked destinations and/or ZOC problems
    for (Unit* u in didntMove)
        [u setMps:0];
    
    // TODO: compute whether game over
}

#pragma mark - Private Methods

- (BOOL)is:(Unit*)unit movingThruEnemyZocTo:(Hex)hex {
    HexMapGeometry* g = [_board geometry];
    
    int moveDir = [g directionFrom:[unit location] to:hex];
    int cwDir   = [g rotateDirection:moveDir clockwise:YES];
    int ccwDir  = [g rotateDirection:moveDir clockwise:NO];
    
    Unit* cwUnit  = [_oob unitInHex:[g hexAdjacentTo:[unit location] inDirection:cwDir]];
    Unit* ccwUnit = [_oob unitInHex:[g hexAdjacentTo:[unit location] inDirection:ccwDir]];

    return (cwUnit  && ![cwUnit  friends:unit])
        || (ccwUnit && ![ccwUnit friends:unit]);
}

// Performs sighting from the POV of player `side'. In practice will
// most usually be called with side parameter == _userSide attribute,
// but doing it this way allows more convenient testing and debugging.
- (void)doSighting:(PlayerSide)side {

    // TODO: friends and enemies should be methods on OOB

    NSArray* friends = [[_oob units] grep:^BOOL(id u) { return [u side] != OtherPlayer(side); }];
    NSArray* enemies = [[_oob units] grep:^BOOL(id u) { return [u side] == OtherPlayer(side); }];
    
    [friends enumerateObjectsUsingBlock:^(id friend, NSUInteger idx, BOOL* stop) {
        if ([[_board geometry] legal:[friend location]]) {
            if (![friend sighted]) {
                [friend setSighted:YES];
                [(BRAppDelegate*)[[UIApplication sharedApplication] delegate] unitNowSighted:friend];
            }
        }
        // doesn't handle case of on-board unit moving off-board
     }];

    [enemies enumerateObjectsUsingBlock:^(id enemy, NSUInteger idx, BOOL* stop) {
        BOOL enemyNowSighted = NO;
        
        // Ignore units unless they are on the map
        if ([[_board geometry] legal:[enemy location]]) {
        
            Terrain* terrain = [[Terrain alloc] initWithInt:[_board terrainAt:[enemy location]]];
        
            // CSA north of river or USA south of river is always spotted (note that fords
            // are marked as on both sides of the river, so units on fords are always spotted).
            if ([terrain isEnemy:side]) {
                DEBUG_SIGHTING(@"%@ is in enemy territory", [enemy name]);
                enemyNowSighted = YES;
                
            } else {
                enemyNowSighted = [self isUnit:enemy inTerrain:terrain sightedBy:friends];
            }

            // if enemy is no longer sighted, but used to be, update it
            if (!enemyNowSighted && [enemy sighted]) {
                [enemy setSighted:NO];
                [(BRAppDelegate*)[[UIApplication sharedApplication] delegate] unitNowHidden:enemy];
                
            } else if (enemyNowSighted && ![enemy sighted]) {
                [enemy setSighted:YES];
                [(BRAppDelegate*)[[UIApplication sharedApplication] delegate] unitNowSighted:enemy];
            }
        }
        // Note that we're not handling the case of an on-board unit moving off-board.
    }];
}

// Returns YES if `enemy' situated in given terrain is sighted by any of `friends'.
- (BOOL)isUnit:(Unit*)enemy inTerrain:(Terrain*)terrain sightedBy:(NSArray*)friends {
    
    // Innocent until proven guilty.
    __block BOOL sighted = NO;
    
    [friends enumerateObjectsUsingBlock:^(id friend, NSUInteger idx, BOOL* stop) {
        // Friends which are offboard can't spot.
        if (![[_board geometry] legal:[friend location]])
            return;
        
        // Friendly units within three hexes sight enemies...
        if ([[_board geometry] distanceFrom:[friend location] to:[enemy location]] < 4) {
            
            // ...as long as both units are on the same side of the river
            Terrain* friendlyTerrain = [[Terrain alloc] initWithInt:[_board terrainAt:[friend location]]];
            
            if ([friendlyTerrain onSameSideOfRiver:terrain]) {
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
                                    Unit* u1 = obj1;
                                    Unit* u2 = obj2;
                                    
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
