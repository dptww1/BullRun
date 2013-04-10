//
//  HMCoordinateTransformer.h
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMGeometry.h"

@interface HMCoordinateTransformer : NSObject

@property (nonatomic, strong) HMGeometry* geometry;
@property (nonatomic)         CGPoint     origin;
@property (nonatomic)         CGSize      hexSize;

- (id)initWithGeometry:(HMGeometry*)geometry origin:(CGPoint)origin hexSize:(CGSize)hexSize;
- (CGPoint)hexToScreen:(HMHex)hex;
- (CGPoint)hexCenterToScreen:(HMHex)hex;
- (HMHex)screenToHex:(CGPoint)point;

@end
