//
//  MoveOrders.m
//  Bull Run
//
//  Created by Dave Townsend on 1/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Hex.h"
#import "MoveOrders.h"
#import "ResizableBuffer.h"

@implementation MoveOrders

- (id)init {
    self = [super init];
    
    if (self) {
        _list = [ResizableBuffer bufferWithCapacity:20 ofObjectSize:sizeof(Hex)];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    MoveOrders* newObj = [[MoveOrders alloc] init];
    
    if (newObj)
        [newObj setList:[self.list copyWithZone:zone]];
    
    return newObj;
}

- (BOOL)isEmpty {
    return [_list isEmpty];
}

- (void)clear {
    [_list clear];
}

- (void)addHex:(Hex)hex {
    [_list add:&hex];
}

- (int)numHexes {
    return [_list count];
}

- (Hex)lastHex {
    return [self hex:[_list count] - 1];
}

- (Hex)firstHexAndRemove:(BOOL)removeOrder {
    if ([_list count] == 0)
        return HexMake(-1, -1);
    
    Hex hex = [self hex:0];
    
    if (removeOrder)
        [_list remove:0];

    return hex;
}

- (Hex)hex:(int)idx {
    if (0 <= idx && idx < [_list count])
        return *((Hex*)[_list getObjectAt:idx]);
    
    return HexMake(-1, -1);
}

- (BOOL)isBacktrack:(Hex)hex {
    if ([_list count] < 2)
        return NO;
    
    Hex penultimate = [self hex:[_list count] - 2];
    return HexEquals(hex, penultimate);
}

- (void)backtrack {
    [self.list setCount:[_list count] - 1];
}

@end
