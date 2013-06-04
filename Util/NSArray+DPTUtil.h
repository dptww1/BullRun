//
//  NSArray+DPTUtil.h
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Block type for use in the filtering methods in this category.
 */
typedef BOOL (^DPTUtilFilter)(id o);

/**
 * Functional programming extensions for `NSArray`.
 */
@interface NSArray (DPTUtil)

/**
 * Returns the first element in this array for which `condBlock`
 * returns `YES`.
 *
 * @param condBlock block used to evaluate the elements in this array
 *
 * @return the first matching element, or `nil` if no elements match
 */
- (id)dpt_find:(DPTUtilFilter)condBlock;

/**
 * Returns all the elements in this array for which `condBlock`
 * returns `YES`.
 *
 * @param condBlock block used to evaluate the elements in this array
 *
 * @return an array of the elements matching the condition (possibly empty)
 */
- (NSArray*)dpt_grep:(DPTUtilFilter)condBlock;

@end
