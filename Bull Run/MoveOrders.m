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
    return [self.list isEmpty];
}

- (void)clear {
    [self.list clear];
}

- (void)addHex:(Hex)hex {
    [self.list add:&hex];
}

- (int)numHexes {
    return [self.list count];
}

- (Hex)lastHex {
    return [self hex:[self.list count] - 1];
}

- (Hex)firstHexAndRemove:(BOOL)removeOrder {
    if ([self.list count] == 0)
        return HexMake(-1, -1);
    
    Hex hex = [self hex:0];
    
    if (removeOrder)
        [self.list remove:0];

    return hex;
}

- (Hex)hex:(int)idx {
    if (0 <= idx && idx < [self.list count])
        return *((Hex*)[self.list getObjectAt:idx]);
    
    return HexMake(-1, -1);
}

- (BOOL)isBacktrack:(Hex)hex {
    if ([self.list count] < 2)
        return NO;
    
    Hex penultimate = [self hex:[self.list count] - 2];
    return HexEquals(hex, penultimate);
}

- (void)backtrack {
    [self.list setCount:[self.list count] - 1];
}

@end
