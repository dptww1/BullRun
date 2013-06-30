//
//  BATAIInfluenceMap.m
//
//  Created by Dave Townsend on 5/24/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//


#import "BATAIInfluenceMap.h"


//==============================================================================
@interface BATAIInfluenceMap ()

@property (nonatomic)        float*  mapData;
@property (nonatomic,strong) HXMMap* srcMap;

@end


//==============================================================================
@implementation BATAIInfluenceMap (Private)

- (int)offsetForHex:(HXMHex)hex {
    return hex.row * [[[self srcMap] geometry] numColumns] + hex.column;
}

@end


//==============================================================================
@implementation BATAIInfluenceMap

+ (BATAIInfluenceMap*)mapFrom:(HXMMap*)board {
    BATAIInfluenceMap* map = [[BATAIInfluenceMap alloc] init];

    if (map) {
        [map setSrcMap:board];
        [map setMapData:malloc(sizeof(float) * [board numCells])];
        [map zeroOut];
    }

    return map;
}

- (void)zeroOut {
    float* p = _mapData;
    for (int i = 0; i < [_srcMap numCells]; ++i)
        *p++ = 0.0f;
}

- (void)addValue:(float)value atHex:(HXMHex)hex {
    if ([_srcMap legal:hex])
        _mapData[[self offsetForHex:hex]] += value;
}

- (void)setValue:(float)value atHex:(HXMHex)hex {
    if ([_srcMap legal:hex])
        _mapData[[self offsetForHex:hex]] = value;
}

- (float)valueAt:(HXMHex)hex {
    if ([[self srcMap] legal:hex])
        return _mapData[[self offsetForHex:hex]];

    return 0.0f;
}

- (float)multiplyBy:(float)value atHex:(HXMHex)hex {
    if ([_srcMap legal:hex]) {
        int offset = [self offsetForHex:hex];
        _mapData[offset] *= 4.0f;
        return _mapData[offset];
    }

    return 0.0f;
}

- (HXMHexAndDistance)largestValue {
    HXMHexAndDistance hexd;
    hexd.hex = HXMHexMake(-1, -1);
    hexd.distance = 0;

    for (int row = 0; row < [[_srcMap geometry] numRows]; ++row) {
        for (int col = 0; col < [[_srcMap geometry] numColumns]; ++col) {
            HXMHex curHex = HXMHexMake(col, row);
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
    for (int row = 0; row < [[_srcMap geometry] numRows]; ++row) {
        for (int col = 0; col < [[_srcMap geometry] numColumns]; ++col) {
            printf("%3d ", (int)_mapData[row * [[_srcMap geometry] numColumns] + col]);
        }
        printf("\n");
    }
}

@end
