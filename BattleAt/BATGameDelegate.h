//
//  BATGameDelegate.h
//  Bull Run
//
//  Created by Dave Townsend on 8/6/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "HexMap.h"


@class BATUnit;

/**
 * Protocol enumerating the game-specific methods which need to be 
 * implemented for use of the generic game engine.
 */
@protocol BATGameDelegate <NSObject>

/**
 * Called at beginning of turn to assign new movement points to all
 * the units in the game.
 */
- (void)allotMovementPoints;

/**
 * Determines if any friendly units sight the given enemy unit located in the
 * given hex.
 *
 * @param enemy
 * @param hex
 * @param friends
 * 
 * @return `TRUE` if a friend sighted the enemy, else `FALSE`
 */
- (BOOL)isUnit:(BATUnit*)enemy inHex:(HXMHex)hex sightedBy:(NSArray*)friends;

/**
 * Converts a turn number to a human-readable string.
 *
 * @param turn the turn number to convert
 *
 * @return a game-specific, human-readable string corresponding to the turn
 *
 * @see convertStringToTurn:
 */
- (NSString*)convertTurnToString:(int)turn;

/**
 * Converts a string (such as produced by `convertTurnToString:`) to a
 * turn number.
 *
 * @param string the game-specific string to convert
 *
 * @return the turn number, or 0 if the input string is uninterpretable
 */
- (int)convertStringToTurn:(NSString*)string;

/**
 * Returns the list of possible mode names for the given unit. The ordering
 * can be arbitrary but return consistent results across repeated calls for
 * the same unit.
 *
 * @param unit the unit to get the mode strings for
 *
 * @return the mode names, as NSArray of NSString*; never `nil`
 */
- (NSArray*)getPossibleModesForUnit:(BATUnit*)unit;

/**
 * Returns the mode number corresponding to the given mode string.  The mode
 * number is not necessarily the index of the passed string within the return
 * results of `getPossibleModesForUnit:`, but any given combination of
 * parameters should consistently return the same index.
 *
 * @param unit the unit to get the mode index for
 * @param modeString the mode string to look up
 *
 * @return the mode index
 *
 * @throws "Bad Mode string" exception if `modeString` is not a known mode
 */
- (int)getModeIndexForUnit:(BATUnit*)unit inMode:(NSString*)modeString;

/**
 * Gets the mode string for the unit's current mode.
 *
 * @unit unit to get mode string for
 *
 * @return the mode string
 */
- (NSString*)getCurrentModeStringForUnit:(BATUnit*)unit;

@end
