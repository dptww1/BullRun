//
//  NSArray+DPTUtil.h
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Block type used by the filtering methods in this category. */
typedef BOOL (^DPTUtilFilter)(id o);

/** Block type used by the numeric methods in this category. */
typedef NSNumber* (^DPTNumericBlock)(id o);

/** Block type used by the mapping methods in this category. */
typedef id (^DPTMapBlock)(id o);

/** Functional programming extensions for `NSArray`. */
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

/**
 * Returns a copy of this array with each element being the corresponding
 * source element as processed by `mapBlock`.
 *
 * @param mapBlock the mapping logic
 *
 * @returns the mapped array
 */
- (NSArray*)dpt_map:(DPTMapBlock)mapBlock;

/**
 * Runs `evalBlock` on each element of this array and returns the index
 * of the element having the smallest resulting value. If multiple
 * elements return the same value, the index of the first element
 * encountered is returned.
 *
 * @param evalBlock the block to run for each element
 * 
 * @return the index of the smallest element, or -1 if the array is empty
 */
- (int)dpt_min_idx:(DPTNumericBlock)evalBlock;

/**
 * Runs `evalBlock` on each element of this array and returns the index
 * of the element having the largest resulting value. If multiple
 * elements return the same value, the index of the first element
 * encountered is returned.
 *
 * @param evalBlock the block to run for each element
 *
 * @return the index of the largest element, or -1 if the array is empty
 */
- (int)dpt_max_idx:(DPTNumericBlock)evalBlock;

@end
