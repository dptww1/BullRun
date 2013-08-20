//
//  BATOrderOfBattle.h
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BattleAt.h"
#import "HexMap.h"

@class BATReinforcementInfo;
@class BATUnit;

/**
 * The collection of units in the game.
 */
@interface BATOrderOfBattle : NSObject

/** 
 * Array of `BATUnit`s, in arbitrary order. Not mutable, as must always contain
 * all the units that could possibly appear in play.
 */
@property (nonatomic, strong) NSArray* units;

/** 
 * Array of `BATReinforcementInfo` structures, describing the reinforcements
 * in use during play. This is mutable so that it can be adjusted dynamically,
 * to handle variable reinforcements based on user choices.
 */
@property (nonatomic, strong) NSMutableArray* reinforcements;

/**
 * Creates an order of battle from a file.
 *
 * @param filepath the complete pathname to load from
 *
 * @return the initialized object
 */
+ (BATOrderOfBattle*)createFromFile:(NSString*)filepath;

/**
 * Saves this OOB to the given filename.
 *
 * @param filename the filename (with no path elements, just the filename)
 *
 * @return `YES` if the save operation worked, `NO` if it didn't
 */
- (BOOL)saveToFile:(NSString*)filename;

/**
 * Finds a unit in this OOB by name.
 *
 * @param name the unit name
 *
 * @return the corresponding unit
 *
 * @exception NSException no unit of the given name exists
 */
- (BATUnit*)unitByName:(NSString*)name;

/**
 * Retrieves all the units for the given side.
 *
 * @param side the side to get the units for
 *
 * @return an array of all units for that side, in arbitrary order
 */
- (NSArray*)unitsForSide:(BATPlayerSide)side;

/**
 * Deletes reinforcement info for the given unit. Safe to call even
 * if there isn't any reinforcement info for the unit.
 *
 * @param unitName the unit name whose info should be deleted
 */
- (void)deleteReinforcementInfoForUnitName:(NSString*)unitName;

/**
 * Removes the given unit entirely from the game, whether it's already
 * deployed or is a reinforcement, or is already out of the game.
 *
 * @param unitName the name of the unit to remove
 */
- (void)removeFromGame:(NSString*)unitName;

/**
 * Deploys the given unit at the given hex, erasing any reinforcement
 * information for the unit, if any.
 *
 * @param unitName the name of the unit to deploy
 * @param hex where to deploy the unit
 */
- (void)addStartingUnit:(NSString*)unitName atHex:(HXMHex)hex;

/**
 * Adds the given unit as a reinforcement. The unit is removed from the map
 * if it is already deployed.
 *
 * @param unitName the name of the unit to make a reinforcement
 * @param hex where the reinforcement should arrive
 * @param turn the turn of arrival of the reinforcement
 */
- (void)addReinforcingUnit:(NSString*)unitName atHex:(HXMHex)hex onTurn:(int)turn;

@end
