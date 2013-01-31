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
    
    NSArray* sortedUnits = [self sortUnits];
    
    // All units get 5 new MPs
    for (Unit* u in sortedUnits) {
        [u setMps:[u mps] + 5];
    }
    
    // Because lower-rated units can block higher-rated units, we have to keep processing until no moves were possible.
    BOOL atLeastOneUnitMoved = YES;
    while (atLeastOneUnitMoved) {
        atLeastOneUnitMoved = NO;
        
        for (Unit* u in sortedUnits) {
            if (![[_board geometry] legal:[u location]] || ![u hasOrders])
                continue;
            
            Hex nextHex = [[u moveOrders] firstHexAndRemove:NO];
            
            // Is it occupied?
            Unit* blocker = [_oob unitInHex:nextHex];
            if (blocker) {
                if ([u friends:blocker]) // friendly blocker
                    ;// TODO
                else // enemy blocker: combat!
                    ;// TODO
                
            } else {  // destination hex is empty
                
                // TODO: terrain cost
                // TODO: ZOC problem
                
                [(BRAppDelegate*)[[UIApplication sharedApplication] delegate] moveUnit:u to:nextHex];
                [[u moveOrders] firstHexAndRemove:YES];
                [u setLocation:nextHex];
            }
        }
    }
    
    // TODO: compute whether game over
}

#pragma mark - Private Methods

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
                NSLog(@"%@ is in enemy territory", [enemy name]);
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
                NSLog(@"%@ spots %@", [friend name], [enemy name]);
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
