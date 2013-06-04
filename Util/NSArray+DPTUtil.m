//
//  NSArray+DPTUtil.m
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "NSArray+DPTUtil.h"

@implementation NSArray (DPTUtil)

- (id)dpt_find:(DPTUtilFilter)condBlock {
    __block id foundObj = nil;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        if (condBlock(obj)) {
            foundObj = obj;
            *stop = YES;
        }
     }];

    return foundObj;
}

- (NSArray*)dpt_grep:(DPTUtilFilter)condBlock {
    NSMutableArray* result = [NSMutableArray array];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        if (condBlock(obj))
            [result addObject:obj];
     }];
    
    return result;
}

@end
