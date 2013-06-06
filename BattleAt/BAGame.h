//
//  BAGame.h
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAIProtocol.h"
#import "BAGameObserving.h"
#import "BAOrderOfBattle.h"
#import "BullRun.h"
#import "HMMap.h"

@class BAUnit;

/**
 * A game, tying together the board (an `HMMap`), the units (via a
 * `BAOrderOfBattle`), plus housekeeping information.  
 *
 * Designed to be used as a base class for a battle-specific derived class.
 */
@interface BAGame : NSObject

/** 
 * The current AI that the human player is playing against. Since this is
 * battle-specific, this must be set in the derived class's initializer.
 */
@property (nonatomic, strong)           id<BAAIProtocol> ai;

/** The side which represents the human player. */
@property (nonatomic)                   PlayerSide       userSide;

/** The mapboard used by this game. */
@property (nonatomic, strong, readonly) HMMap*           board;

/** The order of battle used by this game. */
@property (nonatomic, strong, readonly) BAOrderOfBattle* oob;

/** A list of observers */
@property (nonatomic, assign, readonly) int              turn;

/**
 * Sets the player side to the parameter.
 *
 * @param newSide the side which the user represents
 */
- (void)hackUserSide:(PlayerSide)newSide;

/**
 * Adds an observer of this game.
 *
 * @param observer the observer to add
 */
- (void)addObserver:(id<BAGameObserving>)observer;

/**
 * Performs sighting from the point of view of player `side`. Ordinarily this
 * will be `[self userSide]`, but that's not hardwired here to facilitate
 * testing and debugging.
 *
 * @param side the POV of the sighting
 * 
 */
- (void)doSighting:(PlayerSide)side;

/**
 * Begins processing the turn. Orders are implemented, game events trigger
 * callbacks, and the turn is advanced.
 */
- (void)processTurn;

/**
 * Finds the unit in the given hex.
 *
 * @param hex the hex in question
 * 
 * @return the unit in the given hex, or `nil` if none
 */
- (BAUnit*)unitInHex:(HMHex)hex;

@end

/** The single, publicly available global instance. */
extern BAGame* game;

