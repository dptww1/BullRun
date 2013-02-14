//
//  HMGeometry.h
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

/**
 * Structure defining the basic geometry of a hexmap, a two-dimensional array of hexagons. 
 * Checkerboards are easy to represent because they naturally map to two-dimensional arrays in programs.
 * Not so with hexmaps, which will one axis which has alternate rows (or columns) with staggered steps
 * and an extra cell.
 * <p>
 * Some definitions:
 * <ul>
 * <li>The <i>grain</i> defines whether hexagon sides or vertices face the top edge of the hexmap.  If
 * sides, then the hexmap is <i>short-grained</i>, if vertices then the hexmap is <i>long-grained</i>.
 * <li>The <i>long</i> rows/columns along the grain of the map have an extra hexagon.
 * </ul>
 *
 * <p>Here's a typical hexmap:
 * <tt>
 *    __    __    __
 *   /  \__/  \__/  \
 *   \__/  \__/  \__/
 *   /  \__/  \__/  \
 *   \__/  \__/  \__/
 *   /  \__/  \__/  \
 *   \__/  \__/  \__/
 *   /  \__/  \__/  \
 *   \__/  \__/  \__/
 * </tt>
 *
 * <p>In terms of the initialization arguments, this would be
 * <ol>
 * <li><tt>isLongGrain</tt> is <tt>FALSE</tt>, because this is a short-grain map (sides face the top, not vertices)
 * <li><tt>firstColumnIsLong</tt> is <tt>TRUE</tt>, because the first column has one more hex than the second column
 * <li><tt>numRows</tt> is 3; the extra hex caused by the grain in the first, third, and fifth columns is ignored
 * <li><tt>numColumns</tt> is 5
 * </ol>
 */
@interface HMGeometry : NSObject <NSCoding>

@property (nonatomic) BOOL isLongGrain;
@property (nonatomic) BOOL firstColumnIsLong;
@property (nonatomic) int  numRows;
@property (nonatomic) int  numColumns;

/**
 * Designated initializer.
 */
- (id)initWithLongGrain:(BOOL)longGrain firstColumnIsLong:(BOOL)firstColumnIsLong numRows:(int)rows numColumns:(int)columns;

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
 * Returns next hex in given direction from starting hex. The return value is not
 * guaranteed to be legal!
 */
- (HMHex)hexAdjacentTo:(HMHex)start inDirection:(int)dir;

@end
