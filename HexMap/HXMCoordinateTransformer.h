//
//  HXMCoordinateTransformer.h
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMHex.h"


@class HXMMap;


/**
 * Manages the conversion between screen coordinates and hex coordinates.
 */
@interface HXMCoordinateTransformer : NSObject

/** The map model to translate. */
@property (nonatomic, strong, readonly) HXMMap* map;

/** The screen pixel coordinate of the upper left corner of hex (0,0). */
@property (nonatomic, assign, readonly) CGPoint origin;

/** The pixel size of a hex. */
@property (nonatomic, assign, readonly) CGSize  hexSize;

/**
 * Designated initializer.
 *
 * @param map the source map
 * @param origin the screen pixel coordinate of the upper left corner of hex 0,0
 * @param hexSize the pixel size of a hex
 *
 * @return the initialized object
 */
- (id)initWithMap:(HXMMap*)map origin:(CGPoint)origin hexSize:(CGSize)hexSize;

/**
 * Converts the given hex coordinate to screen coordinates.
 *
 * @param hex the hex coordinate to convert
 *
 * @return the upper left corner of the hex in pixels
 */
- (CGPoint)hexToScreen:(HXMHex)hex;

/**
 * Converts the given hex coordinate to screen coordinates.
 *
 * @param hex the hex coordinate to convert
 *
 * @return the center of the hex in pixels
 */
- (CGPoint)hexCenterToScreen:(HXMHex)hex;

/**
 * Converts the given screen coordinate to the corresponding hex coordinate.
 *
 * @param point the screen point to convert
 *
 * @return the corresponding hex location, or (-1,-1) if no such hex
 */
- (HXMHex)screenToHex:(CGPoint)point;

@end
