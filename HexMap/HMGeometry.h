

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
 * @code
 *    __    __    __
 *   /  \__/  \__/  \
 *   \__/  \__/  \__/
 *   /  \__/  \__/  \
 *   \__/  \__/  \__/
 *   /  \__/  \__/  \
 *   \__/  \__/  \__/
 *   /  \__/  \__/  \
 *   \__/  \__/  \__/
 * @endcode
 *
 * <p>In terms of the initialization arguments, this would be
 * <ol>
 * <li><tt>isLongGrain</tt> is <tt>FALSE</tt>, because this is a short-grain map
 *     (sides face the top, not vertices)
 * <li><tt>firstColumnIsLong</tt> is <tt>TRUE</tt>, because the first column has
 *     one more hex than the second column
 * <li><tt>numRows</tt> is 3; the extra hex caused by the grain in the first, 
 *     third, and fifth columns is ignored
 * <li><tt>numColumns</tt> is 5
 * </ol>
 *
 * Hexes within the hexmap are always zero-indexed, so (0,0) is the upper left 
 * corner.
 */
@interface HMGeometry : NSObject <NSCoding>

/** `YES` if this is a long grain map, `NO` if it's short-grain. */
@property (nonatomic,readonly) BOOL isLongGrain;

/** `YES` if the first column is long, `NO` if the second column is long. */
@property (nonatomic,readonly) BOOL firstColumnIsLong;

/** Number of rows in the map, not including the extra row in long columns. */
@property (nonatomic,readonly) int  numRows;

/** Number of columns in the map. */
@property (nonatomic,readonly) int  numColumns;

/**
 * Designated initializer.
 *
 * @param longGrain the grainedness of the hex map
 * @param firstColumnIsLong `YES` if the first (third, fifth...) column is long,
 *                          `NO` if the second (fourth, sixth...) column is long
 * @param rows the number of rows in all columns; the "long" columns will
 *             have an extra row
 * @param columns the number of columns in the map
 */
- (id)initWithLongGrain:(BOOL)longGrain
      firstColumnIsLong:(BOOL)firstColumnIsLong
                numRows:(int)rows
             numColumns:(int)columns;


@end
