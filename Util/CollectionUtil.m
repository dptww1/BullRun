//
//  CollectionUtil.m
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "CollectionUtil.h"

@implementation NSArray (CollectionUtil)

- (NSArray*)grep:(BOOL (^)(id o))condBlock {
    NSMutableArray* result = [NSMutableArray array];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        if (condBlock(obj))
            [result addObject:obj];
     }];
    
    return result;
}

@end
