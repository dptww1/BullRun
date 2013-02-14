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

#define HexMake(col, row) ((HMHex){ (col), (row) })
#define HexEquals(h1, h2) ((h1).row == (h2).row && (h1).column == (h2).column)
