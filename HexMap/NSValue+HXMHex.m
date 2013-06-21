//
//  NSValue+HXMHex.m
//  Bull Run
//
//  Created by Dave Townsend on 5/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "NSValue+HXMHex.h"

@implementation NSValue (HXMHex)

+ (id)valueWithHex:(HXMHex)hex {
    return [NSValue value:&hex withObjCType:@encode(HXMHex)];
}

- (HXMHex)hexValue {
    HXMHex hex;
    [self getValue:&hex];
    return hex;
}

@end
