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

typedef NSNumber* (^DPTNumericFilter)(id o);

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
- (int)dpt_min_idx:(DPTNumericFilter)evalBlock;

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
- (int)dpt_max_idx:(DPTNumericFilter)evalBlock;

@end
