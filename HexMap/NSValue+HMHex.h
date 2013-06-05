//
//  NSValue+HMHex.h
//  Bull Run
//
//  Created by Dave Townsend on 5/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

/** 
 * NSValue wrapping support for HMHex structures, which allow
 * hexes to be put into the iOS collections.
 */
@interface NSValue (HMHex)

/**
 * Returns a `NSValue` for the given hex.
 * 
 * @param hex the hex to wrap
 */
+ (id)valueWithHex:(HMHex)hex;

/**
 * Returns the hex that this object wraps.
 *
 * @return the hex value
 */
- (HMHex)hexValue;

@end
