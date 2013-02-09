//
//  Board.h
//  Bull Run
//
//  Created by Dave Townsend on 1/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BullRun.h"   // TODO This is bad
#import "HexMapGeometry.h"
#import "Hex.h"

@class Unit;

@interface Board : NSObject <NSCoding>

@property (readonly, strong, nonatomic) HexMapGeometry* geometry;
@property (readonly, strong, nonatomic) NSArray*        terrainEffects;
@property (readonly, strong, nonatomic) NSDictionary*   zones;
@property (readonly,         nonatomic) int*            mapData;

+ (Board*)createFromFile:(NSString*)filename;

- (BOOL)saveToFile:(NSString*)filename;
- (float)mpCostOf:(Hex)hex for:(Unit*)unit;
- (BOOL)isEnemy:(Hex)hex of:(PlayerSide)side;  // TODO:BR-specific
- (BOOL)is:(Hex)hex inSameZoneAs:(Hex)other;
- (BOOL)is:(Hex)hex inZone:(NSString*)zoneName;

@end
