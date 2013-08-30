//
//  NSString+DPTUtil.h
//  Bull Run
//
//  Created by Dave Townsend on 8/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Programming extensions for NSString. */
@interface NSString (DPTUtil)

/**
 * Returns the integral bounding box needed to render this
 * string using the given font.
 *
 * @param font the font to use for computation
 *
 * @return the size of the bounding box, rounded "outward" to integral coordinates
 */
- (CGRect)dpt_integralBoundsUsingFont:(UIFont*)font;

@end
