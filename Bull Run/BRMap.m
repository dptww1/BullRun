//
//  BRMap.m
//  Bull Run
//
//  Created by Dave Townsend on 5/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BRMap.h"

@implementation BRMap

- (BOOL)isCsa:(HMHex)hex {
    return [self is:hex inZone:@"csa"];
}

- (BOOL)isUsa:(HMHex)hex {
    return [self is:hex inZone:@"usa"];
}

- (BOOL)isEnemy:(HMHex)hex of:(PlayerSide)side { // TODO: generalize?
    return (side == CSA && [self isUsa:hex])
        || (side == USA && [self isCsa:hex]);
}

@end
