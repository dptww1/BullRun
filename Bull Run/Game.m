//
//  Game.m
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BRAppDelegate.h"
#import "Game.h"
#import "BullRun.h"
#import "OrderOfBattle.h"
#import "CollectionUtil.h"
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
        _board = [[Board alloc] init];
        _oob = [OrderOfBattle createFromFile:[[NSBundle mainBundle] pathForResource:@"units" ofType:@"plist"]];
        
        [self doSighting:USA];
    }

    return self;
}

#pragma mark - Private Methods

// Performs sighting from the POV of player `side'. In practice will
// most usually be called with side parameter == userSide attribute,
// but doing it this way allows more convenient testing and debugging.
- (void)doSighting:(PlayerSide)side {

    // TODO: friends and enemies should be methods on OOB

    NSArray* friends = [[_oob units] grep:^BOOL(id u) { return [u side] != OtherPlayer(side); }];
    NSArray* enemies = [[_oob units] grep:^BOOL(id u) { return [u side] == OtherPlayer(side); }];

    [enemies enumerateObjectsUsingBlock:^(id enemy, NSUInteger idx, BOOL* stop) {
        __block BOOL enemyWasSighted = NO;
        
        // Ignore units unless they are on the map
        if (![[_board geometry] legal:[enemy location]])
            return;
        
        // TODO: Units on a ford hex are always spotted
        
        // TODO: CSA north of river or USA south of river is always spotted
        
        // Friendly units within three hexes sight enemies
        // TODO: ...as long as both units are on the same side of the river
        [friends enumerateObjectsUsingBlock:^(id friend, NSUInteger idx, BOOL* stop) {
            // friends which are offboard can't spot
            if (![[_board geometry] legal:[friend location]])
                return;
            
            if ([[_board geometry] distanceFrom:[friend location] to:[enemy location]] < 4) {
                NSLog(@"%@ spots %@", [friend name], [enemy name]);
                
                // If enemy unit used to be spotted, and still is, there's nothing to do.  But
                // if it used to be hidden, we need to update it.
                if (![enemy sighted]) {
                    [enemy setSighted:YES];
                    enemyWasSighted = YES;
                    [(BRAppDelegate*)[[UIApplication sharedApplication] delegate] unitNowSighted:enemy];
                }
                    
                // no point in continuing to iterate
                *stop = YES;
            }
         }];

        // if enemy is no longer sighted, but used to be, update it
        if (!enemyWasSighted && [enemy sighted]) {
            [(BRAppDelegate*)[[UIApplication sharedApplication] delegate] unitNowHidden:enemy];
        }
    }];
    
    // TODO: enemies not in the dictionary but which are currently
}

@end
