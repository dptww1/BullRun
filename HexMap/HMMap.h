//
//  HMMap.h
//  Bull Run
//
//  Created by Dave Townsend on 1/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMGeometry.h"
#import "HMHex.h"
#import "HMTerrainEffect.h"

@class BAUnit;

@interface HMMap : NSObject <NSCoding>

@property (readonly, strong, nonatomic) HMGeometry*   geometry;
@property (readonly, strong, nonatomic) NSArray*      terrainEffects;
@property (readonly, strong, nonatomic) NSDictionary* zones;
@property (readonly,         nonatomic) int*          mapData;

+ (HMMap*)createFromFile:(NSString*)filename;

- (BOOL)saveToFile:(NSString*)filename;
- (float)mpCostOf:(HMHex)hex for:(BAUnit*)unit;    // TODO: no BA allowed in HM!
- (BOOL)is:(HMHex)hex inSameZoneAs:(HMHex)other;
- (BOOL)is:(HMHex)hex inZone:(NSString*)zoneName;
- (HMTerrainEffect*)terrainAt:(HMHex)hex;
- (BOOL)is:(HMHex)hex prohibitedFor:(BAUnit*)unit; // TODO: no BA allowed in HM!

- (HMTerrainEffect*)findTerrainByName:(NSString*)name;

// Return value: array of NSValue-wrapped HMHexes
- (NSArray*)findHexesOfType:(NSString*)terrainName;

/**
 * Determine if the given hex defines a legal location for this hexmap.
 */
- (BOOL)legal:(HMHex)hex;

/**
 * Determines the distance between two hexes.  If either or both are not legal, returns -1.
 */
- (int)distanceFrom:(HMHex)hex to:(HMHex)hex;

/**
 * Returns the number of cells needed to represent the entire game map.
 */
- (int)numCells;

/**
 * Returns the direction between two hexes.  Unlike distanceFrom:to:, the order of the parameters
 * is important!  The directions are:
 *
 *     0
 *  5 ---  1
 *   /   \
 *   \   /
 *  4 ---  2
 *     3
 *
 * where direction 0 points in the direction of the "top" of the map (i.e. row 0).
 * If from == to direction is 0.
 */
- (int)directionFrom:(HMHex)from to:(HMHex)to;

/**
 * Returns the normalized direction next to the given direction in either the
 * clockwise (cw == YES) or counterclockwise (cw == NO) direction.
 */
- (int)rotateDirection:(int)dir clockwise:(BOOL)cw;

/**
 * Normalizes the direction to be in the range (0..6).
 */
- (int)normalizeDirection:(int)dir;

/**
 * Returns next hex in given direction from starting hex. The return value is not
 * guaranteed to be legal!
 */
- (HMHex)hexAdjacentTo:(HMHex)start inDirection:(int)dir;

@end
