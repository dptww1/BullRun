//
//  DPTResizableBuffer.h
//  Bull Run
//
//  Created by Dave Townsend on 2/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Array storage for structures. Written before I discovered how to wrap
 * structures in NSValues using categories, which can then be stuffed in
 * an NSArray. Probably useless now (though I'd guess this is faster)
 * but it seems silly to get rid of it since it appears to work and it's in use.
 * Like NSArray, it grows as needed to accomodate the data that you add to it.
 */
@interface DPTResizableBuffer : NSObject <NSCopying>

/** The size of the structures stored in the buffer. */
@property (nonatomic,readonly) int objectSize;

/** 
 * The maximum number of items which can be stored in the buffer
 * without resizing. Really for internal use, as it can change after any
 * `add` operation.
 */
@property (nonatomic,readonly) int capacity;

/**
 * The actual number of items currently stored in the buffer. Note that this
 * property is writeable. Reducing the count is the same as truncating the
 * data in the buffer by the given number of items. Increasing the count
 * will yield garbage.
 */
@property (nonatomic) int count;

/**
 * Convenience class initializer.
 *
 * @param capacity the # of items which the buffer can hold without resizing
 * @param objSize the size of items to be stored in the buffer
 *
 * @return an empty buffer
 */
+ (id)bufferWithCapacity:(int)capacity ofObjectSize:(int)objSize;

/**
 * Designated initializer.
 *
 * @param capacity the # of items which the buffer can hold without resizing
 * @param objSize the size of items to be stored in the buffer
 *
 * @return an empty buffer
 */
- (id)initWithCapacity:(int)capacity ofObjectSize:(int)objSize;

/**
 * Determines if the buffer is empty.
 *
 * @return `YES` if the buffer is empty, `NO` if it isn't
 */
- (BOOL)isEmpty;

/**
 * Empties the buffer.  `count` will be 0 after running this method.
 */
- (void)clear;

/**
 * Copies the given object into the buffer at its end. It is the caller's
 * responsibility to ensure that the object is the same size as passed to
 * the designated initializer.
 *
 * @param object the object to copy into the buffer
 */
- (void)add:(void*)object;

/**
 * Returns a pointer to the object at the given index. The pointer points
 * to internal data within the buffer, not a copy of the object.
 *
 * It is the caller's responsibility to ensure that 0 <= `idx` < `count`.
 *
 * @param idx the index of the object to return
 */
- (void*)getObjectAt:(int)idx;

/**
 * Removes the object at the given index from the buffer; objects added
 * after the removed object will move!
 *
 * It is the caller's responsibility to ensure that 0 <= `idx` < `count`.
 *
 * @param idx the index of the object to remove
 */
- (void)remove:(int)idx;

@end
