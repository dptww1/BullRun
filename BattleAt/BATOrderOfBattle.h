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
 * @return the corresponding unit, or `nil` if no such unit exists
 */
- (BATUnit*)unitByName:(NSString*)name;

/**
 * Retrieves all the units for the given side.
 *
 * @param side the side to get the units for
 *
 * @return an array of all units for that side, in arbitrary order
 */
- (NSArray*)unitsForSide:(PlayerSide)side;

/**
 * Adds reinforcement information to this OOB.
 *
 * @param reinforcementInfo the reinforcement to add
 */
- (void)addReinforcementInfo:(BATReinforcementInfo*)reinforcementInfo;

@end
