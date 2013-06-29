//
//  BAAAnimationListItem.m
//  Bull Run
//
//  Created by Dave Townsend on 4/16/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAAAnimationListItem.h"
#import "HXMCoordinateTransformer.h"


@class BATUnit;


float SECONDS_PER_HEX_MOVE = 0.75f;

@implementation BAAAnimationListItem

- (CAAnimation*)createMoveAnimationFor:(BATUnit*)unit
                            movingFrom:(HXMHex)startHex
                                    to:(HXMHex)endHex
                            usingXform:(HXMCoordinateTransformer*)xform {
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"position"];
    [anim setDuration:SECONDS_PER_HEX_MOVE];
    [anim setFromValue:[NSValue valueWithCGPoint:[xform hexCenterToScreen:startHex]]];
    [anim setToValue:[NSValue valueWithCGPoint:[xform hexCenterToScreen:endHex]]];
    return anim;
}

- (void)runWithParent:(BAAAnimationList*)list {
    // does nothing by default
}

@end
