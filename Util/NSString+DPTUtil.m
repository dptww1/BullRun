//
//  NSString+DPTUtil.m
//  Bull Run
//
//  Created by Dave Townsend on 8/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "NSString+DPTUtil.h"

@implementation NSString (DPTUtil)

- (CGRect)dpt_integralBoundsUsingFont:(UIFont*)font {
    CGSize size = [self sizeWithFont:font];
    CGRect fbounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
    return CGRectIntegral(fbounds);
}

@end
