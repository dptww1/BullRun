//
//  CALayer+DPTUtil.h
//
//  Created by Dave Townsend on 8/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

/** Programming extensions for CALayer. */
@interface CALayer (DPTUtil)

/**
 * Sets all drop shadowing parameters at once
 *
 * @param color shadow color (note type: not CGColor!)
 * @param opacity shadow opacity
 * @param offset shadow offset
 * @param radius shadow radius
 *
 */
- (void)dpt_setShadowColor:(UIColor*)color
                   opacity:(float)opacity
                    offset:(CGSize)offset
                    radius:(float)radius;


@end
