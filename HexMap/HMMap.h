//
//  HMMap.h
//  Bull Run
//
//  Created by Dave Townsend on 1/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BullRun.h"   // TODO This is bad
#import "HMGeometry.h"
#import "HMHex.h"
#import "TerrainEffect.h"

@class Unit;

@interface HMMap : NSObject <NSCoding>

@property (readonly, strong, nonatomic) HMGeometry*   geometry;
@property (readonly, strong, nonatomic) NSArray*      terrainEffects;
@property (readonly, strong, nonatomic) NSDictionary* zones;
@property (readonly,         nonatomic) int*          mapData;

+ (HMMap*)createFromFile:(NSString*)filename;

- (BOOL)saveToFile:(NSString*)filename;
- (float)mpCostOf:(HMHex)hex for:(Unit*)unit;
- (BOOL)isEnemy:(HMHex)hex of:(PlayerSide)side;  // TODO:BR-specific
- (BOOL)is:(HMHex)hex inSameZoneAs:(HMHex)other;
- (BOOL)is:(HMHex)hex inZone:(NSString*)zoneName;
- (TerrainEffect*)terrainAt:(HMHex)hex;

@end
