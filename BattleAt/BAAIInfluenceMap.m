//
//  BAAIInfluenceMap.m
//  Bull Run
//
//  Created by Dave Townsend on 5/24/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAAIInfluenceMap.h"
#import "HMMap.h"

@interface BAAIInfluenceMap ()

@property (nonatomic)        float*      mapData;
@property (nonatomic,strong) HMGeometry* geometry;

@end


@implementation BAAIInfluenceMap

+ (BAAIInfluenceMap*)mapFrom:(HMMap*)board {
    BAAIInfluenceMap* map = [[BAAIInfluenceMap alloc] init];

    if (map) {
        HMGeometry* geometry = [board geometry];

        [map setGeometry:geometry];
        [map setMapData:malloc(sizeof(float) * [geometry numCells])];
        [map zeroOut];
    }

    return map;
}

- (void)zeroOut {
    float* p = [self mapData];
    for (int i = 0; i < [[self geometry] numCells]; ++i)
        *p++ = 0.0f;
}

- (void)addValue:(float)value atHex:(HMHex)hex {
    [self mapData][hex.row * [[self geometry] numColumns] + hex.column] += value;
}

- (void)setValue:(float)value atHex:(HMHex)hex {
    [self mapData][hex.row * [[self geometry] numColumns] + hex.column] = value;
}

- (float)valueAt:(HMHex)hex {
    return [self mapData][hex.row * [[self geometry] numColumns] + hex.column];
}

- (void)dump {
    NSLog(@"Influence map:");
    for (int row = 0; row < [[self geometry] numRows]; ++row) {
        for (int col = 0; col < [[self geometry] numColumns]; ++col) {
            printf("%3d ", (int)[self mapData][row * [[self geometry] numColumns] + col]);
        }
        printf("\n");
    }
}

@end
