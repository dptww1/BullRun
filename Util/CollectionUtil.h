//
//  CollectionUtil.h
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CollectionUtil)

typedef BOOL (^CUFilter)(id o);

- (NSArray*)find:(CUFilter)condBlock;
- (NSArray*)grep:(CUFilter)condBlock;

@end
