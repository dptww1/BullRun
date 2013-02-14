//
//  HexMapCoordinateTransformer.h
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HexMapGeometry.h"

@interface HexMapCoordinateTransformer : NSObject

@property (nonatomic, strong) HexMapGeometry* geometry;
@property (nonatomic)         CGPoint         origin;
@property (nonatomic)         CGSize          hexSize;

- (id)initWithGeometry:(HexMapGeometry*)geometry origin:(CGPoint)origin hexSize:(CGSize)hexSize;
- (CGPoint)hexToScreen:(HMHex)hex;
- (HMHex)screenToHex:(CGPoint)point;

@end
