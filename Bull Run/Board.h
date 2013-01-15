//
//  Board.h
//  Bull Run
//
//  Created by Dave Townsend on 1/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HexMapGeometry.h"
#import "Hex.h"


@interface Board : NSObject <NSCoding>

@property (readonly, strong) HexMapGeometry* geometry;
@property (readonly)         int*            mapData;

+ (Board*)createFromFile:(NSString*)filename;
- (BOOL)saveToFile:(NSString*)filename;
- (int)terrainAt:(Hex)hex;

@end
