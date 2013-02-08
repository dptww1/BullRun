//
//  ResizableBuffer.m
//  Bull Run
//
//  Created by Dave Townsend on 2/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "ResizableBuffer.h"

@implementation ResizableBuffer (Private)

- (const char*)serializationFmt {
    NSLog(@"SerializationFmt:[%dc]/%s", self.objectSize, @encode(NSRange));
    return [[NSString stringWithFormat:@"[%dc]", self.objectSize] UTF8String];
}

@end

@implementation ResizableBuffer

#pragma mark - Init Methods

+ (id)bufferWithCapacity:(int)capacity ofObjectSize:(int)objSize {
    return [[ResizableBuffer alloc] initWithCapacity:capacity ofObjectSize:objSize];
}

- (id)initWithCapacity:(int)capacity ofObjectSize:(int)objSize {
    self = [super init];
    
    if (self) {
        _buffer     = malloc(capacity * objSize);
        _count      = 0;
        _capacity   = capacity;
        _objectSize = objSize;
    }
    return self;
    
}

- (id)copyWithZone:(NSZone*)zone {
    ResizableBuffer* newObj = [ResizableBuffer bufferWithCapacity:self.capacity ofObjectSize:self.objectSize];
    
    if (newObj && self.count > 0) {
        [newObj setCount:self.count];
        memcpy([newObj buffer], self.buffer, self.count * self.objectSize);
    }
    
    return newObj;
}

#pragma mark - NSCopying Implementation

- (void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeInt:   self.capacity                      forKey:@"capacity"];
    [encoder encodeInt:   self.count                         forKey:@"count"];
    [encoder encodeInt:   self.objectSize                    forKey:@"objectSize"];
    // TODO: Buffer -- never could get this working
}

- (id)initWithCoder:(NSCoder*)decoder {
    self = [super init];
    
    if (self) {
        self.capacity   = [decoder decodeIntForKey:@"capacity"];
        self.count      = [decoder decodeIntForKey:@"count"];
        self.objectSize = [decoder decodeIntForKey:@"objectSize"];
        
        self.buffer     = malloc(self.capacity * self.objectSize);
        // TODO: Buffer -- never could get this working
    }
    
    return self;
}

#pragma mark - Housekeeping

- (void)dealloc {
    if (self.buffer != NULL)
        free(self.buffer);
    self.buffer = NULL;
}


#pragma mark - Behaviors

- (BOOL)isEmpty {
    return self.count == 0;
}

- (void)clear {
    self.count = 0;
}

- (void)add:(void*)object {
    // Increase size if buffer is full
    if (self.count == self.capacity) {
        self.capacity *= 2;
        self.buffer = realloc(self.buffer, self.capacity * self.objectSize);
    }
    
    memcpy(&self.buffer[self.count * self.objectSize], object, self.objectSize);
    self.count += 1;
}

// REQUIRE: 0 <= idx < count
- (void*)getObjectAt:(int)idx {
    return &self.buffer[idx * self.objectSize];
}

// REQUIRE: 0 <= idx < count
- (void)remove:(int)idx {
    void* copy = malloc(self.objectSize * self.capacity);
    
    // If we're removing the last object, we don't actually have to do anything.
    if (idx <= self.count - 1) {
        // Copy over everything
        memcpy(copy, self.buffer, self.objectSize * self.capacity);
    
        // Now close up the hole
        memcpy(&self.buffer[idx * self.objectSize],
               &copy[(idx + 1) * self.objectSize],
               (self.count - idx) * self.objectSize);
    }
    
    self.count -= 1;
}

@end
