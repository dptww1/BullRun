//
//  HMMap.m
//  Bull Run
//
//  Created by Dave Townsend on 1/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "CollectionUtil.h"
#import "HMMap.h"
#import "HMGeometry.h"
#import "HMHex.h"
#import "HMMapZone.h"
#import "HMTerrainEffect.h"
#import "SysUtil.h"


// Default capacity for findHexesOfType:
#define DEFAULT_CAPACITY 12


@implementation HMMap (Private)

- (int)rawDataAt:(HMHex)hex {
    return [self mapData][(hex.row * [[self geometry] numColumns]) + hex.column];
}

@end

@implementation HMMap

// Variable is read-only; this is declared here but not in header to keep it private(ish).
- (void)setTerrainEffects:(NSArray*)a {
    _terrainEffects = a;
}


#pragma - mark Init Methods
+ (HMMap*)createFromFile:(NSString*)filepath {
    HMMap* board = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
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

- (HMTerrainEffect*)terrainAt:(HMHex)hex {
    if (![_geometry legal:hex])
        return nil;

    int rawData = [self rawDataAt:hex];

    if (rawData == 0)
        return nil;

    // Loop through the bits LSB to MSB
    for (HMTerrainEffect* te in [self terrainEffects]) {
        if (rawData & (1 << [te bitNum]))
            return te;
    }

    return nil;
}

- (float)mpCostOf:(HMHex)hex for:(BAUnit*)unit {
    HMTerrainEffect* fx = [self terrainAt:hex];
    return fx ? [fx mpCost] : 10000.0f;
}

- (BOOL)is:(HMHex)hex inSameZoneAs:(HMHex)other {
    for (NSString* zname in [self.zones keyEnumerator]) {
        if ([self is:hex inZone:zname] && [self is:other inZone:zname])
            return YES;
    }
    
    return NO;
}

- (BOOL)is:(HMHex)hex inZone:(NSString*)zoneName {
    HMMapZone* zone = [self.zones objectForKey:zoneName];
    if (!zone)
        return NO;
    
    return [zone containsHex:hex];
}

- (BOOL)is:(HMHex)hex prohibitedFor:(BAUnit*)unit {
    return ![self terrainAt:hex];
}

- (HMTerrainEffect*)findTerrainByName:(NSString *)name {
    return (HMTerrainEffect*)
           [[self terrainEffects]
            find:^BOOL(HMTerrainEffect* o) {
                return [[o name] isEqualToString:name];
            }];
}

- (NSArray*)findHexesOfType:(NSString *)terrainName {
    NSMutableArray* list = [NSMutableArray arrayWithCapacity:DEFAULT_CAPACITY];

    HMTerrainEffect* fx = [self findTerrainByName:terrainName];
    HMGeometry* geometry = [self geometry];

    if (fx) {
        int bitMask = 1 << [fx bitNum];

        for (int row = 0; row < [geometry numRows] + 1; ++row) {
            for (int col = 0; col < [geometry numColumns]; ++col) {
                HMHex hex = HMHexMake(col, row);
                if ([geometry legal:hex] && [self rawDataAt:hex] & bitMask) {
                    [list addObject:[NSValue value:&hex withObjCType:@encode(HMHex)]];
                }
            }
        }
    }

    return list;
}

@end
