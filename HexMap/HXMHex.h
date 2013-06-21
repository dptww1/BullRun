/*! @file HXMHex.h */
//
//  HXMHex.h
//  Bull Run
//
//  Created by Dave Townsend on 12/25/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

/**
 * Coordinates of a single hex location.
 * @see HXMHexMake, HXMHexEquals
 */
typedef struct {
    int column;   /**< the hex column */
    int row;      /**< the hex row */
} HXMHex;

/**
 * A hex plus an extra integer field, for when functions need to return
 * information about a hex plus the hex itself.
 */
typedef struct {
    HXMHex hex;         /**< the hex */
    int    distance;    /**< the extra information */
} HXMHexAndDistance;

/**
 * Constructs a new `HXMHex` from the given coordinates.
 * 
 * @param col the hex column
 * @param row the hex row
 *
 * @return the new hex
 */
#define HXMHexMake(col, row) ((HXMHex){ (col), (row) })

/**
 * Compares two hexes for equality. As with many macros, this may 
 * evaluate its arguments more than once.
 *
 * @param h1 the first hex to compare
 * @param h2 the second hex to compare
 *
 * @return non-zero if the hexes are the same, zero if they differ
 */
#define HXMHexEquals(h1, h2) ((h1).row == (h2).row && (h1).column == (h2).column)
