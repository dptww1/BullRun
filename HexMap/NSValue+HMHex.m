//
//  NSValue+HMHex.m
//  Bull Run
//
//  Created by Dave Townsend on 5/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "NSValue+HMHex.h"

@implementation NSValue (HMHex)

+ (id)valueWithHex:(HMHex)hex {
    return [NSValue value:&hex withObjCType:@encode(HMHex)];
}

- (HMHex)hexValue {
    HMHex hex;
    [self getValue:&hex];
    return hex;
}

@end
