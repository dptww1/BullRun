//
//  BATAIInfluenceMap.h
//
//  Created by Dave Townsend on 5/24/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMHex.h"

@class HXMMap;

/**
 * A map of abstract values for use by the AI routines.  There is a single
 * floating-point value per hex.
 */
@interface BATAIInfluenceMap : NSObject

/**
 * Creates an influence map, initialized with 0f values for all hexes.
 *
 * @param board the board that the influence map should represent
 */
+ (BATAIInfluenceMap*)mapFrom:(HXMMap*)board;

/**
 * Returns the hex coordinate and actual value of the hex with the 
 * largest value in the influence map.
 * 
 * @return the largest-valuehex and the value
 */
- (HXMHexAndDistance)largestValue;

/**
 * Returns the value associated with the given hex.
 *
 * @param hex the hex to get the value for
 *
 * @return the associated value for the hex, or 0f if the hex isn't legal
 */
- (float)valueAt:(HXMHex)hex;

/**
 * Adds the given value to the current value for the given hex.
 *
 * @param value the value to add
 * @param hex the hex for the value
 */
- (void)addValue:(float)value atHex:(HXMHex)hex;

/**
 * Sets the value for the given hex (overwriting any old value).
 *
 * @param value to the value to set
 * @param hex the hex for the value
 */
- (void)setValue:(float)value atHex:(HXMHex)hex;

/**
 * Multiplies the existing value for a hex by a given factor.
 *
 * @param value the factor to multiply the existing value by
 * @param hex the hex for the value
 */
- (float)multiplyBy:(float)value atHex:(HXMHex)hex;

/** Resets all the values in the influence map to zero. */
- (void)zeroOut;

/**
 * NSLogs the influence map's values to the console.
 */
- (void)dump;

@end
