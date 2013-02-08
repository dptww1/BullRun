//
//  ResizableBuffer.h
//  Bull Run
//
//  Created by Dave Townsend on 2/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResizableBuffer;

@interface ResizableBuffer : NSObject <NSCopying>

@property (nonatomic) void* buffer;     // Pointer to actual memory
@property (nonatomic) int   objectSize; // Size of objects stored in buffer
@property (nonatomic) int   capacity;   // max # items of objectSize which can be stored in buffer without resizing
@property (nonatomic) int   count;      // actual number of items stored in buffer

+ (id)bufferWithCapacity:(int)capacity ofObjectSize:(int)objSize;

- (id)initWithCapacity:(int)capacity ofObjectSize:(int)objSize;
- (BOOL)isEmpty;
- (void)clear;
- (void)add:(void*)object;
- (void*)getObjectAt:(int)idx;
- (void)remove:(int)idx;

@end
