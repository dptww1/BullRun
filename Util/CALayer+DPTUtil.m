//
//  CALayer+DPTUtil.m
//
//  Created by Dave Townsend on 8/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "CALayer+DPTUtil.h"

@implementation CALayer (DPTUtil)

- (void)dpt_setShadowColor:(UIColor*)color
                   opacity:(float)opacity
                    offset:(CGSize)offset
                    radius:(float)radius {
    [self setShadowColor:[color CGColor]];
    [self setShadowOpacity:opacity];
    [self setShadowOffset:offset];
    [self setShadowRadius:radius];
}

@end
