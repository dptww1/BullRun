//
//  MoveOrders.m
//  Bull Run
//
//  Created by Dave Townsend on 1/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "MoveOrders.h"
#import "Hex.h"

// Whenever we run out of space, increase capacity by this # of hexes
#define LIST_SIZE_INCREMENT 20

@implementation MoveOrders


- (id)init {
    return [self initWithCapacity:LIST_SIZE_INCREMENT];
}

- (id)initWithCapacity:(int)capacity {
    self = [super init];
    
    if (self) {
        _list     = malloc(sizeof(Hex) * capacity);
        _count    = 0;
        _capacity = capacity;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    MoveOrders* newObj = [[MoveOrders alloc] initWithCapacity:_capacity];
    
    if (newObj) {
        if (_count > 0) {
            newObj.count = _count;
            memcpy(newObj.list, _list, _count * sizeof(Hex));
        }
    }
    
    return newObj;
}

- (void)dealloc {
    if (_list != NULL) {
        free(_list);
        _list = NULL;
    }
}

- (BOOL)isEmpty {
    return _count == 0;
}

- (void)clear {
    _count = 0;
}

- (void)addHex:(Hex)hex {
    // If the buffer is full, increase size
    if (_count == _capacity) {
        _capacity += LIST_SIZE_INCREMENT;
        _list = realloc(_list, sizeof(Hex) * _capacity);
    }
    
    _list[_count++] = hex;
}

- (int)numHexes {
    return _count;
}

- (Hex)lastHex {
    if (_count == 0)
        return HexMake(-1, -1);
    
    return _list[_count - 1];
}

- (Hex)firstHexAndRemove:(BOOL)removeOrder {
    if (_count == 0)
        return HexMake(-1, -1);
    
    Hex hex = _list[0];
    
    if (removeOrder) { // it's a little complicated...
    
        Hex* newList = malloc(sizeof(Hex) * _capacity);
        _count -= 1;
        memcpy(newList, _list + 1, sizeof(Hex) * _count);
        free(_list);
        _list = newList;
    }

    return hex;
}

@end
