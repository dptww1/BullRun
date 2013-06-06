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

/** The speed of movement animations. */
extern float SECONDS_PER_HEX_MOVE;

@class BAAAnimationList;
@class BAUnit;
@class HMCoordinateTransformer;

/**
 * Item suitable for including in a `BAAAnimationList`.
 */
@interface BAAAnimationListItem : NSObject

/**
 * Light wrapper so BAAAnimationListCombat doesn't have to know about its
 * sibling class.  This might be too cute.
 */
- (CAAnimation*)createMoveAnimationFor:(BAUnit*)unit
                            movingFrom:(HMHex)startHex
                                    to:(HMHex)endHex
                            usingXform:(HMCoordinateTransformer*)transformer;

/**
 * Method called by the animation list when it is this item's turn to run.
 * The default implementation of this does nothing, so you almost certainly
 * want to override it.
 *
 * @param list the parent animation list
 */
- (void)runWithParent:(BAAAnimationList*)list;
@end
