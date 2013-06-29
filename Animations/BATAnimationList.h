//
//  BATAnimationList.h
//
//  Created by Dave Townsend on 4/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BATAnimationListItem;
@class HXMCoordinateTransformer;

/**
 * Manages a sequential list of animations.
 */
@interface BATAnimationList : NSObject

/** The coordinate transformer that this object was created with. */
@property (nonatomic, weak, readonly)   HXMCoordinateTransformer* xformer;

/**
 * Designated class initializer.
 *
 * @param xformer the hex-to-screen transformer for the current screen
 *
 * @return the initialized animation list
 */
+ (BATAnimationList*)listWithCoordXFormer:(HXMCoordinateTransformer*)xformer;

/**
 * Adds a new animation item to the end of the current list.
 *
 * @param item the item to add
 */
- (void)addItem:(BATAnimationListItem*)item;

/**
 * Empties the animation list.
 */
- (void)reset;

/**
 * Begins running the animations currently in the list.
 * 
 * @param completionBlock block to run when all animations are complete
 */
- (void)run:(void (^)(void))completionBlock;

@end
