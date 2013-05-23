//
//  HMHex.h
//  Bull Run
//
//  Created by Dave Townsend on 12/25/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

typedef struct {
    int column;
    int row;
} HMHex;

typedef struct {
    HMHex hex;
    int   distance;
} HMHexAndDistance;


#define HMHexMake(col, row) ((HMHex){ (col), (row) })
#define HMHexEquals(h1, h2) ((h1).row == (h2).row && (h1).column == (h2).column)
