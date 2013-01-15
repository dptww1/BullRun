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

#pragma - mark Init Methods
+ (Board*)createFromFile:(NSString*)filepath {
    Board* board = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
    
    return board;
}

#pragma mark - Coding Implementation

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_geometry forKey:@"geometry"];
    [coder encodeArrayOfObjCType:@encode(int)
                           count:[_geometry numCells]
                              at:_mapData];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    _geometry = [decoder decodeObjectForKey:@"geometry"];
    
    _mapData = malloc([_geometry numCells] * sizeof(int));
    
    [decoder decodeArrayOfObjCType:@encode(int)
                             count:[_geometry numCells]
                                at:_mapData];
    
    return self;
}
     

#pragma mark - Behaviors

- (BOOL)saveToFile:(NSString *)filename {
    NSString* path = [[SysUtil applicationFileDir] stringByAppendingPathComponent:filename];
    
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:path];
    
    NSLog(@"Wrote file [%d] %@", success, path);
    
    return success;
}

- (int)terrainAt:(Hex)hex {

    if (![_geometry legal:hex])
        return 0;
    
    return _mapData[(hex.row * [_geometry numColumns]) + hex.column];
}

@end
