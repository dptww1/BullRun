//
//  Board.m
//  Bull Run
//
//  Created by Dave Townsend on 1/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Board.h"
#import "BullRun.h"  // TODO: this is bad; shouldn't import game-specific stuff in library file
#import "Hex.h"
#import "HexMapGeometry.h"
#import "MapZone.h"
#import "SysUtil.h"
#import "TerrainEffect.h"

@implementation Board (Private)

- (int)rawDataAt:(Hex)hex {
    return [self mapData][(hex.row * [[self geometry] numColumns]) + hex.column];
}

@end

@implementation Board

// Variable is read-only; this is declared here but not in header to keep it private(ish).
- (void)setTerrainEffects:(NSArray*)a {
    _terrainEffects = a;
}


#pragma - mark Init Methods
+ (Board*)createFromFile:(NSString*)filepath {
    Board* board = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];

    [board setZones:[NSMutableDictionary dictionary]];
    
    MapZone* zoneCsa = [[MapZone alloc] init];
    [zoneCsa addRange:NSMakeRange( 3, 10) forColumn: 0];
    [zoneCsa addRange:NSMakeRange( 3, 11) forColumn: 1];
    [zoneCsa addRange:NSMakeRange( 2, 11) forColumn: 2];
    [zoneCsa addRange:NSMakeRange( 3, 11) forColumn: 3];
    [zoneCsa addRange:NSMakeRange( 3, 10) forColumn: 4];
    [zoneCsa addRange:NSMakeRange( 5,  9) forColumn: 5];
    [zoneCsa addRange:NSMakeRange( 6,  7) forColumn: 6];
    [zoneCsa addRange:NSMakeRange( 8,  6) forColumn: 7];
    [zoneCsa addRange:NSMakeRange( 8,  5) forColumn: 8];
    [zoneCsa addRange:NSMakeRange( 8,  6) forColumn: 9];
    [zoneCsa addRange:NSMakeRange( 8,  5) forColumn:10];
    [zoneCsa addRange:NSMakeRange( 9,  5) forColumn:11];
    [zoneCsa addRange:NSMakeRange( 9,  4) forColumn:12];
    [zoneCsa addRange:NSMakeRange(11,  1) forColumn:13];
    [(NSMutableDictionary*)[board zones] setObject:zoneCsa forKey:@"csa"];
    
    MapZone* zoneUsa = [[MapZone alloc] init];
    [zoneUsa addRange:NSMakeRange( 0,  2) forColumn: 0];
    [zoneUsa addRange:NSMakeRange( 0,  2) forColumn: 1];
    [zoneUsa addRange:NSMakeRange( 0,  1) forColumn: 2];
    [zoneUsa addRange:NSMakeRange( 0,  2) forColumn: 3];
    [zoneUsa addRange:NSMakeRange( 0,  2) forColumn: 4];
    [zoneUsa addRange:NSMakeRange( 0,  3) forColumn: 5];
    [zoneUsa addRange:NSMakeRange( 0,  4) forColumn: 6];
    [zoneUsa addRange:NSMakeRange( 0,  6) forColumn: 7];
    [zoneUsa addRange:NSMakeRange( 0,  7) forColumn: 8];
    [zoneUsa addRange:NSMakeRange( 0,  7) forColumn: 9];
    [zoneUsa addRange:NSMakeRange( 0,  7) forColumn:10];
    [zoneUsa addRange:NSMakeRange( 0,  8) forColumn:11];
    [zoneUsa addRange:NSMakeRange( 0,  8) forColumn:12];
    [zoneUsa addRange:NSMakeRange( 0,  9) forColumn:13];
    [zoneUsa addRange:NSMakeRange( 0, 10) forColumn:14];
    [zoneUsa addRange:NSMakeRange(12,  1) forColumn:14]; // tricky! two discontinuous ranges in same column
    [zoneUsa addRange:NSMakeRange( 0, 14) forColumn:15];
    [zoneUsa addRange:NSMakeRange( 0, 13) forColumn:16];
    [(NSMutableDictionary*)[board zones] setObject:zoneUsa forKey:@"usa"];
    
    return board;
}

#pragma mark - Coding Implementation

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.geometry forKey:@"geometry"];
    [coder encodeObject:self.terrainEffects forKey:@"terrainEffects"];
    [coder encodeObject:self.zones forKey:@"zones"];
    [coder encodeArrayOfObjCType:@encode(int)
                           count:[self.geometry numCells]
                              at:self.mapData];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    _geometry = [decoder decodeObjectForKey:@"geometry"];
    
    _terrainEffects = [decoder decodeObjectForKey:@"terrainEffects"];
    
    _zones = [decoder decodeObjectForKey:@"zones"];
    
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

- (float)mpCostOf:(Hex)hex for:(Unit*)unit {
    if (![_geometry legal:hex])
        return 0;
    
    int rawData = [self rawDataAt:hex];
    
    if (rawData == 0)
        return 10000.0f;
    
    float cost = 0.0f;
    int thisBit = 0;
    
    // Loop through the bits LSB to MSB; done as soon as no bits left
    while (rawData > 0) {
        for (TerrainEffect* te in [self terrainEffects]) {
            if ([te bitNum] == thisBit)
                cost = [te mpCost]; // TODO: this overwrites previous values; OK for Bull Run but not good in general
        }
        
        thisBit += 1;
        rawData >>= 1;
    }
    
    return cost;
}

- (BOOL)isCsa:(Hex)hex {
    int rawData = [self rawDataAt:hex];
    return rawData & 2;
}

- (BOOL)isUsa:(Hex)hex {
    int rawData = [self rawDataAt:hex];
    return rawData & 1;
}

- (BOOL)isEnemy:(Hex)hex of:(PlayerSide)side {
    return (side == CSA && [self isCsa:hex])
        || (side == USA && [self isUsa:hex]);
}

- (BOOL)is:(Hex)hex inSameZoneAs:(Hex)other {
    return [self rawDataAt:hex] & [self rawDataAt:other] & 3;  // TODO: oh my, my, my, no....
}

- (BOOL)is:(Hex)hex inZone:(NSString*)zoneName {
    MapZone* zone = [self.zones objectForKey:zoneName];
    if (!zone)
        return NO;
    
    return [zone containsHex:hex];
}

@end
