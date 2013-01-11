//
//  CollectionUtil.h
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CollectionUtil)

- (NSArray*)grep:(BOOL (^)(id o))condBlock;

@end
