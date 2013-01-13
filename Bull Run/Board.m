//
//  Board.m
//  Bull Run
//
//  Created by Dave Townsend on 1/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Board.h"
#import "HexMapGeometry.h"
#import "SysUtil.h"
#import "Hex.h"

@implementation Board

- (id)init {
    self = [super init];
    
    if (self) {
        _geometry = [[HexMapGeometry alloc] initWithLongGrain:NO
                                            firstColumnIsLong:NO
                                                      numRows:13
                                                   numColumns:17];
    }
    
    return self;
}

- (BOOL)saveToFile:(NSString *)filename {
    NSString* path = [[SysUtil applicationFileDir] stringByAppendingPathComponent:filename];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:_geometry toFile:path];
    
    NSLog(@"Wrote file [%d] %@", success, path);
    
    return success;
}

- (int)terrainAt:(Hex)hex {
// Bit 0 =  1 => CSA
// Bit 1 =  2 => USA
// Bit 2 =  4 => Cub Run
// Bit 3 =  8 => Woods
// Bit 4 = 16 => Ford
// Bit 5 = 32 => Town
        
static int rawData[14][17] = {
            2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  // Row 0
            2,  2,  0,  2,  2,  2,  2,  2,  2,  2,  6,  2,  2,  2,  2,  2,  2,  // Row 1
            0,  0,  1, 19,  0,  2,  2,  2, 10, 10, 14, 10,  2,  2,  2,  2,  2,  // Row 2
            9,  1,  1,  1,  9, 19,  2,  2, 10,  2,  6,  2,  2, 34,  2,  2,  2,  // Row 3
            9,  9,  9,  1,  1,  0, 19,  2,  2,  6,  2, 10,  2,  2, 10,  2, 10,  // Row 4
            1,  1,  1,  1,  1,  1, 19,  2,  2,  6, 14, 10, 10, 10, 10, 10, 10,  // Row 5
            1,  9,  1,  1,  9,  9,  1, 19,  2, 10, 14, 10,  2, 10,  2,  2, 10,  // Row 6
            1,  1,  1,  1, 33,  1,  1,  0,  0,  0, 19,  2,  2, 10,  2,  2, 10,  // Row 7
            9,  1,  1,  9,  1,  1,  1,  1,  1,  1,  1, 19, 19,  2,  2, 10,  2,  // Row 8
            9,  9,  1,  9,  9,  1,  1,  9,  9,  1,  1,  9,  1, 19, 10,  2,  2,  // Row 9
            1,  1,  1,  1,  1,  1,  9,  9,  9,  9,  1,  1,  1,  0,  0, 10, 10,  // Row 10
            1,  1,  9,  1,  1,  1,  1,  1,  9,  9,  1,  1,  1,  1, 19,  2,  2,  // Row 11
            1,  1,  9,  9,  1,  9,  1,  1,  1, 33,  1,  1,  1, 19, 10,  2,  2,  // Row 12
            0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  0,  0,  2,  0   // Row 13
};


    if (![_geometry legal:hex])
        return 0;
    
    return rawData[hex.row][hex.column];
}

@end
