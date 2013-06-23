//
//  BAAAnimationListItem.h
//  Bull Run
//
//  Created by Dave Townsend on 4/16/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "HXMHex.h"

/** The speed of movement animations. */
extern float SECONDS_PER_HEX_MOVE;

@class BAAAnimationList;
@class BAUnit;
@class HXMCoordinateTransformer;

/**
 * Item suitable for including in a `BAAAnimationList`.
 */
@interface BAAAnimationListItem : NSObject

/**
 * Light wrapper so BAAAnimationListCombat doesn't have to know about its
 * sibling class.  This might be too cute.
 */
- (CAAnimation*)createMoveAnimationFor:(BAUnit*)unit
                            movingFrom:(HXMHex)startHex
                                    to:(HXMHex)endHex
                            usingXform:(HXMCoordinateTransformer*)transformer;

/**
 * Method called by the animation list when it is this item's turn to run.
 * The default implementation of this does nothing, so you almost certainly
 * want to override it.
 *
 * @param list the parent animation list
 */
- (void)runWithParent:(BAAAnimationList*)list;
@end
