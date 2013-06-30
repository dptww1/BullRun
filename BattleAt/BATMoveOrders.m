//
//  BATMoveOrders.m
//
//  Created by Dave Townsend on 1/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "DPTResizableBuffer.h"
#import "BATMoveOrders.h"

//==============================================================================
@interface BATMoveOrders ()

@property (nonatomic, strong) DPTResizableBuffer* list;

@end


//==============================================================================
@implementation BATMoveOrders

- (id)init {
    self = [super init];
    
    if (self) {
        _list = [DPTResizableBuffer bufferWithCapacity:20
                                          ofObjectSize:sizeof(HXMHex)];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    BATMoveOrders* newObj = [[BATMoveOrders alloc] init];
    
    if (newObj)
        [newObj setList:[_list copyWithZone:zone]];
    
    return newObj;
}

- (BOOL)isEmpty {
    return [_list isEmpty];
}

- (void)clear {
    [_list clear];
}

- (void)addHex:(HXMHex)hex {
    [_list add:&hex];
}

- (int)numHexes {
    return [_list count];
}

- (HXMHex)lastHex {
    return [self hex:[_list count] - 1];
}

- (HXMHex)firstHexAndRemove:(BOOL)removeOrder {
    if ([_list count] == 0)
        return HXMHexMake(-1, -1);
    
    HXMHex hex = [self hex:0];
    
    if (removeOrder)
        [_list remove:0];

    return hex;
}

- (HXMHex)hex:(int)idx {
    if (0 <= idx && idx < [_list count])
        return *((HXMHex*)[_list getObjectAt:idx]);

    return HXMHexMake(-1, -1);
}

- (BOOL)isBacktrack:(HXMHex)hex {
    if ([_list count] < 2)
        return NO;
    
    HXMHex penultimate = [self hex:[_list count] - 2];
    return HXMHexEquals(hex, penultimate);
}

- (void)backtrack {
    [self.list setCount:[_list count] - 1];
}

@end
