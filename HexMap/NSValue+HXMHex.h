//
//  NSValue+HXMHex.h
//
//  Created by Dave Townsend on 5/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMHex.h"

/** 
 * NSValue wrapping support for HMHex structures, which allow
 * hexes to be put into the iOS collections.
 */
@interface NSValue (HXMHex)

/**
 * Returns a `NSValue` for the given hex.
 * 
 * @param hex the hex to wrap
 */
+ (id)valueWithHex:(HXMHex)hex;

/**
 * Returns the hex that this object wraps.
 *
 * @return the hex value
 */
- (HXMHex)hexValue;

@end
