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

- (NSArray*)dpt_map:(DPTMapBlock)mapBlock {
    NSMutableArray* result = [NSMutableArray array];

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        [result addObject:mapBlock(obj)];
    }];

    return result;
}

- (int)dpt_min_idx:(DPTNumericBlock)evalBlock {
    __block int       minIdx = -1;
    __block NSNumber* minVal = nil;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        NSNumber* curVal = evalBlock(obj);

        if (idx == 0 || [curVal compare:minVal] == NSOrderedAscending) {
            minIdx = idx;
            minVal = curVal;
        }
    }];

    return minIdx;
}

- (int)dpt_min_idx {
    return [self dpt_min_idx:^NSNumber*(NSNumber* n) { return n; } ];
}

- (int)dpt_max_idx:(DPTNumericBlock)evalBlock {
    __block int       maxIdx = -1;
    __block NSNumber* maxVal = nil;

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        NSNumber* curVal = evalBlock(obj);

        if (idx == 0 || [curVal compare:maxVal] == NSOrderedDescending) {
            maxIdx = idx;
            maxVal = curVal;
        }
    }];

    return maxIdx;
}

- (int)dpt_max_idx {
    return [self dpt_max_idx:^NSNumber*(NSNumber* n) { return n; } ];
}

@end
