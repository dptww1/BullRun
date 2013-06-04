/** @file */
//
//  HMPathFinder.h
//  Bull Run
//
//  Created by Dave Townsend on 5/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

@class HMMap;

/**
 * A user-supplied function which determines the cost of 
 * moving from the "from" hex to the "to" hex.
 *
 * @see HMPathFinder#findPathFrom:to:using:
 */
typedef float (^HMPathFinderCostFn)(HMHex from, HMHex to);

/**
 * Utility class for finding a path between two hexes on a given map.
 */
@interface HMPathFinder : NSObject

/**
 * Convenience class initializer.
 *
 * @param map the map to trace the path on
 * @param minCost the smallest cost possible when moving between hexes on the map.
 *
 * @return an initialized HMPathFinder
 *
 * @see #initForMap:withMinCost:
 */
+ (HMPathFinder*)pathFinderOnMap:(HMMap*)map withMinCost:(float)minCost;

/** 
 * Designated Initializer.  
 *
 * It's important that the "minCost" parameter actually be the absolute smallest
 * value between any two adjacent hexes on the map. For example, for a map
 * where clear terrain costs 1 Movement Point, woods cost 2 MPs, and roads are
 * 1/2 MP, then the proper "minCost" value is 0.5 (because it's the smallest
 * possible value).  Failure to use the proper "minCost" will result in 
 * non-optimals paths.
 *
 * @param map the map to trace the path on
 * @param minCost the smallest cost possible when moving between hexes on the map
 *
 * @return an initialized HMPathFinder
 */
- (HMPathFinder*)initForMap:(HMMap*)map withMinCost:(float)minCost;

/**
 * Finds an optimal path between two hexes, using a user-supplied cost block.
 *
 * The cost block should return the cost of moving between the two hexes passed
 * to it.  If the movement is illegal, the block should return a negative value.
 *
 * @param start the starting hex of the path
 * @param end the ending hex of the path
 * @param fn the user-supplied cost block (must not be nil)
 *
 * @returns an array of NSValue-wrapped HMHexes on the optimal path, with the
 *          first element of the array being the start hex and the last element
 *          of the array being the end hex.  If no path is possible, the array
 *          will be empty.
 */
- (NSArray*)findPathFrom:(HMHex)start to:(HMHex)end using:(HMPathFinderCostFn)fn;

@end
