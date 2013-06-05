/*! @file HMHex.h */
//
//  HMHex.h
//  Bull Run
//
//  Created by Dave Townsend on 12/25/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

/**
 * Coordinates of a single hex location.
 * @see HMHexMake, HMHexEquals
 */
typedef struct {
    int column;   /**< the hex column */
    int row;      /**< the hex row */
} HMHex;

/**
 * A hex plus an extra integer field, for when functions need to return
 * information about a hex plus the hex itself.
 */
typedef struct {
    HMHex hex;         /**< the hex */
    int   distance;    /**< the extra information */
} HMHexAndDistance;

/**
 * Constructs a new `HMHex` from the given coordinates.
 * 
 * @param col the hex column
 * @param row the hex row
 *
 * @return the new hex
 */
#define HMHexMake(col, row) ((HMHex){ (col), (row) })

/**
 * Compares two hexes for equality. As with many macros, this may 
 * evaluate its arguments more than once.
 *
 * @param h1 the first hex to compare
 * @param h2 the second hex to compare
 *
 * @return non-zero if the hexes are the same, zero if they differ
 */
#define HMHexEquals(h1, h2) ((h1).row == (h2).row && (h1).column == (h2).column)
