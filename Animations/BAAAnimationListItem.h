//
//  BAAAnimationListItem.h
//  Bull Run
//
//  Created by Dave Townsend on 4/16/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "HMHex.h"

#define SECONDS_PER_HEX_MOVE 0.75f

@class BAUnit;
@class HMCoordinateTransformer;

@interface BAAAnimationListItem : NSObject

- (CAAnimation*)createMoveAnimationFor:(BAUnit*)unit
                            movingFrom:(HMHex)startHex
                                    to:(HMHex)endHex
                            usingXform:(HMCoordinateTransformer*)transformer;

@end
