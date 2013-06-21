//
//  HMMapZone.h
//  Bull Run
//
//  Created by Dave Townsend on 2/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMHex.h"

/**
 * Encapsulates a map zone.  A "zone" is named collection of hexes (not
 * necessarily contiguous) which are usefully considered together.  Possible
 * uses include defining setup areas, victory point locations, or reinforcement
 * locations.
 */
@interface HMMapZone : NSObject <NSCoding>

/**
 * Designated initializer.
 *
 * @return initialized map zone object
 */
- (id)init;

/**
 * Determines if the given hex is in this object's zone
 * 
 * @param hex the hex to check
 *
 * @return `YES` if the hex is in this zone, `NO` if it isn't
 */
- (BOOL)containsHex:(HXMHex)hex;

/**
 * Adds a given range to a column in this zone. This is useful for building up
 * a zone from scratch, but now isn't really needed since you can specify zones
 * in the data passed to `mkmap`.
 *
 * @param range the range to add
 * @param column the column containing the range
 */
- (void)addRange:(NSRange)range forColumn:(int)column;

@end
