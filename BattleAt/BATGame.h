//
//  BATGame.h
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BattleAt.h"
#import "BATAIDelegate.h"
#import "BATGameDelegate.h"
#import "BATGameObserving.h"
#import "HexMap.h"


@class BATOrderOfBattle;
@class BATUnit;


/**
 * A game, tying together the board (an `HMMap`), the units (via a
 * `BATOrderOfBattle`), plus housekeeping information.  
 *
 * Designed to be used as a base class for a battle-specific derived class.
 */
@interface BATGame : NSObject

/**
 * The game-specific Battle At rules.
 */
@property (nonatomic, strong) id<BATGameDelegate> delegate;

/** 
 * The current AI that the human player is playing against. Since this is
 * battle-specific, this must be set in the derived class's initializer.
 */
@property (nonatomic, strong)           id<BATAIDelegate> ai;

/** The side which represents the human player. */
@property (nonatomic)                   BATPlayerSide     userSide;

/** The mapboard used by this game. */
@property (nonatomic, strong, readonly) HXMMap*           board;

/** The order of battle used by this game. */
@property (nonatomic, strong, readonly) BATOrderOfBattle* oob;

/** A list of observers */
@property (nonatomic, assign, readonly) int               turn;

/**
 * Convenience constructor.
 *
 * @param delegate the game-specific rules
 *
 * @return an initialized game instance
 */
+ (BATGame*)gameWithDelegate:(id<BATGameDelegate>)delegate;

/**
 * Designated initializer.
 *
 * @param delegate the game-specific rules
 *
 * @return an initialized game instance
 */
- (id)initWithDelegate:(id<BATGameDelegate>)delegate;

/**
 * Sets the player side to the parameter.
 *
 * @param newSide the side which the user represents
 */
- (void)hackUserSide:(BATPlayerSide)newSide;

/**
 * Adds an observer of this game.
 *
 * @param observer the observer to add
 */
- (void)addObserver:(id<BATGameObserving>)observer;

/**
 * Performs sighting from the point of view of player `side`. Ordinarily this
 * will be `[self userSide]`, but that's not hardwired here to facilitate
 * testing and debugging.
 *
 * @param side the POV of the sighting
 * 
 */
- (void)doSighting:(BATPlayerSide)side;

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
- (BATUnit*)unitInHex:(HXMHex)hex;

/**
 * Determines if a unit is surrounded by any combination of enemy units,
 * enemy ZOC, friendly units, impassible terrain, or the board edge.
 *
 * @param unit the unit to check
 *
 * @return `YES` if the unit is surrounded, or `NO` if it isn't
 */
- (BOOL)unitIsSurrounded:(BATUnit*)unit;

@end

/** The single, publicly available global instance. */
extern BATGame* game;

