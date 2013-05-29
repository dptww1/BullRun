//
//  BAAIInfluenceMap.m
//  Bull Run
//
//  Created by Dave Townsend on 5/24/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAAIInfluenceMap.h"
#import "HMHex.h"
#import "HMMap.h"

@interface BAAIInfluenceMap ()

@property (nonatomic)        float* mapData;
@property (nonatomic,strong) HMMap* srcMap;

@end

@implementation BAAIInfluenceMap (Private)

- (int)offsetForHex:(HMHex)hex {
    return hex.row * [[[self srcMap] geometry] numColumns] + hex.column;
}

@end

@implementation BAAIInfluenceMap

+ (BAAIInfluenceMap*)mapFrom:(HMMap*)board {
    BAAIInfluenceMap* map = [[BAAIInfluenceMap alloc] init];

    if (map) {
        [map setSrcMap:board];
        [map setMapData:malloc(sizeof(float) * [board numCells])];
        [map zeroOut];
    }

    return map;
}

- (void)zeroOut {
    float* p = [self mapData];
    for (int i = 0; i < [[self srcMap] numCells]; ++i)
        *p++ = 0.0f;
}

- (void)addValue:(float)value atHex:(HMHex)hex {
    if ([[self srcMap] legal:hex])
        [self mapData][[self offsetForHex:hex]] += value;
}

- (void)setValue:(float)value atHex:(HMHex)hex {
    if ([[self srcMap] legal:hex])
        [self mapData][[self offsetForHex:hex]] = value;
}

- (float)valueAt:(HMHex)hex {
    if ([[self srcMap] legal:hex])
        return [self mapData][[self offsetForHex:hex]];

    return 0.0f;
}

- (float)divideBy:(float)value atHex:(HMHex)hex {
    if ([[self srcMap] legal:hex]) {
        int offset = [self offsetForHex:hex];
        [self mapData][offset] /= 4.0f;
        return [self mapData][offset];
    }

    return 0.0f;
}

- (HMHexAndDistance)largestValue {
    HMHexAndDistance hexd;
    hexd.hex = HMHexMake(-1, -1);
    hexd.distance = 0;

    for (int row = 0; row < [[[self srcMap] geometry] numRows]; ++row) {
        for (int col = 0; col < [[[self srcMap] geometry] numColumns]; ++col) {
            HMHex curHex = HMHexMake(col, row);
            float curVal = [self valueAt:curHex];
            if ((int)curVal > hexd.distance) {
                hexd.hex = curHex;
                hexd.distance = (int)curVal;
            }
        }
    }

    return hexd;
}

- (void)dump {
    NSLog(@"Influence map:");
    for (int row = 0; row < [[[self srcMap] geometry] numRows]; ++row) {
        for (int col = 0; col < [[[self srcMap] geometry] numColumns]; ++col) {
            printf("%3d ", (int)[self mapData][row * [[[self srcMap] geometry] numColumns] + col]);
        }
        printf("\n");
    }
}

@end
