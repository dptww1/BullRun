//
//  HXMMap.h
//
//  Created by Dave Townsend on 1/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMGeometry.h"
#import "HXMHex.h"


@class HXMTerrainEffect;


/**
 * A hex map, based on what is needed to support a (war)game.
 */
@interface HXMMap : NSObject <NSCoding>

/** The size and geometry of the map. */
@property (readonly,strong,nonatomic) HXMGeometry* geometry;

/**
 * Creates a map based on the data in the file, which must have been created 
 * with the `mkmap` tool.
 * 
 * @param filename the map file
 *
 * @return the map
 */
+ (HXMMap*)createFromFile:(NSString*)filename;

/**
 * Gets movement cost (in MPs) of given hex.
 *
 * @param hex to get movement cost of
 *
 * @return movement cost
 */
- (float)mpCostOf:(HXMHex)hex;

/**
 * Determines if the given hex is prohibited for movement. This could be
 * because the coordinates are offmap, or because the terrain in the hex
 * is prohibited.
 *
 * @param hex to check
 *
 * @return `YES` if the hex is prohibited, `NO` if it isn't
 */
- (BOOL)isProhibited:(HXMHex)hex;

/**
 * @privatesection
 * For unit tests only!
 */
- (HXMMap*)initWithGeometry:(HXMGeometry*)geometry;

/**
 * Saves this map in the given file.
 * 
 * @param filename where to save the map
 *
 * @return `YES` on success, `NO` on failure
 */
- (BOOL)saveToFile:(NSString*)filename;

/**
 * Determines if two hexes are in the same zone.
 *
 * @param hex the first hex to check
 * @param other the second hex to check
 *
 * @return `YES` if the hexes are in the same zone, `NO` if they aren't
 */
- (BOOL)is:(HXMHex)hex inSameZoneAs:(HXMHex)other;

/**
 * Determine if a hex is in the given zone.
 *
 * @param hex the hex to check
 * @param zoneName the zone name to check
 *
 * @return `YES` if the hex is in the zone, `NO` if it isn't or the zone
 *         doesn't exist
 */
- (BOOL)is:(HXMHex)hex inZone:(NSString*)zoneName;

/**
 * Gets the terrain information for the given hex.
 *
 * @param hex the hex to check
 *
 * @return the relevant terrain effect, or `nil` if the hex is offmap
 *         or impassable
 */
- (HXMTerrainEffect*)terrainAt:(HXMHex)hex;

/**
 * Gets the terrain information by name.
 *
 * @param name the terrain name to get
 *
 * @return the corresponding terrain effect, or `nil` if none
 */
- (HXMTerrainEffect*)findTerrainByName:(NSString*)name;

/**
 * Returns the hexes matching a given terrain type.
 *
 * @param terrainName the terrain name for the hexes to get
 *
 * @return an array of `NSValue`-wrapped `HMHexes` matching that terrain
 *         type, possibly empty
 */
- (NSArray*)findHexesOfType:(NSString*)terrainName;

/**
 * Determine if the given hex defines a legal location for this hexmap. Note
 * "legal" here is solely in terms of coordinates and has nothing to do with
 * any terrain effects.
 * 
 * @param hex the hex to check for legality
 *
 * return `YES` if the hex is legal, `NO` if it isn't
 */
- (BOOL)legal:(HXMHex)hex;  // TODO: rename to isOnMap

/**
 * Determines the distance (in hexes) between two hexes.
 *
 * @param from the source hex
 * @param to the destination hex
 * 
 * @return the distance in hexes, or -1 if either/both hexes are off map
 */
- (int)distanceFrom:(HXMHex)from to:(HXMHex)to;

/**
 * Returns the number of cells needed to represent the entire game map, 
 * including the extra row in the long columns.
 *
 * @return the number of cells
 */
- (int)numCells;

/**
 * Returns the direction between two hexes.  Unlike `distanceFrom:to:`, the
 * order of the parameters is important!  The directions are:
 * @code
 *     0
 *  5 ---  1
 *   /   \
 *   \   /
 *  4 ---  2
 *     3
 *@endcode
 * where direction 0 points in the direction of the "top" of the map (i.e. row
 * 0). If `from == to` then direction is 0.
 *
 * @param from the source hex
 * @param to the destination hex
 *
 * @return the direction, 0-5
 */
- (int)directionFrom:(HXMHex)from to:(HXMHex)to;

/**
 * Returns the normalized direction next to the given direction.
 *
 * @param dir the starting direction
 * @param cw `YES` if the desired rotation is clockwise, `NO` if it's
 *           counterclockwise.
 *
 * @return the neighboring direction number
 */
- (int)rotateDirection:(int)dir clockwise:(BOOL)cw;

/**
 * Normalizes the direction to be in the range (0..5).
 *
 * @param dir the direction to normalize; can be negative
 *
 * @return the equivalent normalized direction
 */
- (int)normalizeDirection:(int)dir;

/**
 * Returns next hex in given direction from starting hex. The return value is 
 * not guaranteed to be on map!
 *
 * @param start the starting hex
 * @param dir the direction (need not be normalized) of the hex to find
 *
 * @return the adjacent hex
 */
- (HXMHex)hexAdjacentTo:(HXMHex)start inDirection:(int)dir;

@end
