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

- (BOOL)isCsa:(Hex)hex { // TODO: move to derived class
    return [self is:hex inZone:@"csa"];
}

- (BOOL)isUsa:(Hex)hex { // TODO: move to derived class
    return [self is:hex inZone:@"usa"];

}

- (BOOL)isEnemy:(Hex)hex of:(PlayerSide)side { // TODO: generalize or move to derived class
    return (side == CSA && [self isUsa:hex])
        || (side == USA && [self isCsa:hex]);
}

- (BOOL)is:(Hex)hex inSameZoneAs:(Hex)other {
    for (NSString* zname in [self.zones keyEnumerator]) {
        if ([self is:hex inZone:zname] && [self is:other inZone:zname])
            return YES;
    }
    
    return NO;
}

- (BOOL)is:(Hex)hex inZone:(NSString*)zoneName {
    MapZone* zone = [self.zones objectForKey:zoneName];
    if (!zone)
        return NO;
    
    return [zone containsHex:hex];
}

@end
