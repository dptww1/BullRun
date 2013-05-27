//
//  HMCoordinateTransformer.h
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMMap.h"

@interface HMCoordinateTransformer : NSObject

@property (nonatomic, strong) HMMap*  map;
@property (nonatomic)         CGPoint origin;
@property (nonatomic)         CGSize  hexSize;

- (id)initWithMap:(HMMap*)map origin:(CGPoint)origin hexSize:(CGSize)hexSize;
- (CGPoint)hexToScreen:(HMHex)hex;
- (CGPoint)hexCenterToScreen:(HMHex)hex;
- (HMHex)screenToHex:(CGPoint)point;

@end
