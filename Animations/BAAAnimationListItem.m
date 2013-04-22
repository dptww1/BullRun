//
//  BAAAnimationListItem.m
//  Bull Run
//
//  Created by Dave Townsend on 4/16/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAAAnimationListItem.h"
#import "BAUnit.h"
#import "HMCoordinateTransformer.h"

@implementation BAAAnimationListItem

- (CAAnimation*)createMoveAnimationFor:(BAUnit*)unit
                            movingFrom:(HMHex)startHex
                                    to:(HMHex)endHex
                            usingXform:(HMCoordinateTransformer*)xform {
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"position"];
    [anim setDuration:SECONDS_PER_HEX_MOVE];
    [anim setFromValue:[NSValue valueWithCGPoint:[xform hexCenterToScreen:startHex]]];
    [anim setToValue:[NSValue valueWithCGPoint:[xform hexCenterToScreen:endHex]]];
    return anim;
}

@end
